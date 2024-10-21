import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:showwcase_v3/core/network/api_error.dart';
import 'package:showwcase_v3/core/network/network_provider.dart';
import 'package:showwcase_v3/core/storage/app_storage.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class SpacesRepository {

  final NetworkProvider networkProvider;
  SpacesRepository(this.networkProvider);

  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };


  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  StreamStateCallback? onAddRemoteStream;

  Future<Either<ApiError, Stream<QuerySnapshot<Map<String, dynamic>>>>> fetchOngoingSpaces() async {
    try {

      // todo replace firebase with our backend
      FirebaseFirestore db = FirebaseFirestore.instance;
       final collection = db.collection('spaces');

      final stream = collection.snapshots();
      return Right(stream);

    }catch(e) {
      return Left(ApiError(errorDescription: e.toString()));
    }
  }

  Future<Either<ApiError, void>> createNewSpace({required String title}) async {

    try {
      final currentUser = AppStorage.currentUserSession!;

      // todo replace firebase with our backend
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference roomRef = db.collection('spaces').doc();

      debugPrint('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);
      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      /// Code for collecting ICE candidates below
      var callerCandidatesCollection = roomRef.collection('callerCandidates');
      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        debugPrint('Got candidate: ${candidate.toMap()}');
        callerCandidatesCollection.add(candidate.toMap());
      };
      /// End of Code for collecting ICE candidate


      /// code for creating a space
      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);
      debugPrint('Created offer: $offer');

      /// send the offer to db
      Map<String, dynamic> spaceWithOffer = {
        'title': title,
        'offer': offer.toMap(),
        'creator': currentUser.toJson()
      };
      await roomRef.set(spaceWithOffer);
      // var roomId = roomRef.id;
      // debugPrint('New space created with SDK offer. Room ID: $roomId');

      peerConnection?.onTrack = (RTCTrackEvent event) {
        debugPrint('Got remote track: ${event.streams[0]}');

        event.streams[0].getTracks().forEach((track) {
          debugPrint('Add a track to the remoteStream $track');
          remoteStream?.addTrack(track);
        });
      };

      /// Listening for remote session description below
      //! This can be in a separate function -------
      roomRef.snapshots().listen((snapshot) async {
        debugPrint('Got updated room: ${snapshot.data()}');

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          debugPrint("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      });


      /// Listen for remote Ice candidates below
      //! This can be in a separate function -------
      roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
            debugPrint('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        }
      });

      return const Right(null);

    }catch(e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }

  Future<void> openUserMedia(RTCVideoRenderer localVideo, RTCVideoRenderer remoteVideo,) async {

    var stream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});

    localVideo.srcObject = stream;
    localStream = stream;
    remoteVideo.srcObject = await createLocalMediaStream('key');

  }

  /// For creator only
  Future<void> hangUp({required String spaceId, required RTCVideoRenderer localVideo}) async {

    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    var db = FirebaseFirestore.instance;
    var roomRef = db.collection('spaces').doc(spaceId);
    var calleeCandidates = await roomRef.collection('calleeCandidates').get();
    for (var document in calleeCandidates.docs) {
      document.reference.delete();
    }

    var callerCandidates = await roomRef.collection('callerCandidates').get();
    for (var document in callerCandidates.docs) {
      document.reference.delete();
    }

    await roomRef.delete();

    localStream!.dispose();
    remoteStream?.dispose();
  }

  /// For participant only
  Future<Either<ApiError, dynamic>> joinSpace({required String spaceId, required RTCVideoRenderer remoteVideo}) async {

    try {

      final currentUser = AppStorage.currentUserSession!;

      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference roomRef = db.collection('spaces').doc(spaceId);
      var roomSnapshot = await roomRef.get();
      debugPrint('Got room ${roomSnapshot.exists}');

      if (roomSnapshot.exists) {
        debugPrint('Create PeerConnection with configuration: $configuration');
        peerConnection = await createPeerConnection(configuration);

        registerPeerConnectionListeners();

        localStream?.getTracks().forEach((track) {
          peerConnection?.addTrack(track, localStream!);
        });

        // Code for collecting ICE candidates below
        var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
        peerConnection?.onIceCandidate = (RTCIceCandidate? candidate) {
          if (candidate == null) {
            debugPrint('onIceCandidate: complete!');
            return;
          }
          debugPrint('onIceCandidate: ${candidate.toMap()}');
          calleeCandidatesCollection.add(candidate.toMap());
        };
        // Code for collecting ICE candidate above

        peerConnection?.onTrack = (RTCTrackEvent event) {
          debugPrint('Got remote track: ${event.streams[0]}');
          event.streams[0].getTracks().forEach((track) {
            debugPrint('Add a track to the remoteStream: $track');
            remoteStream?.addTrack(track);
          });
        };

        // Code for creating SDP answer below
        var data = roomSnapshot.data() as Map<String, dynamic>;
        debugPrint('Got offer $data');
        var offer = data['offer'];
        await peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );
        var answer = await peerConnection!.createAnswer();
        debugPrint('Created Answer $answer');

        await peerConnection!.setLocalDescription(answer);

        Map<String, dynamic> roomWithAnswer = {
          'answer': {'type': answer.type, 'sdp': answer.sdp},
          'participant' :  currentUser.toJson()
        };

        await roomRef.update(roomWithAnswer);
        // Finished creating SDP answer

        // Listening for remote ICE candidates below
        roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
          for (var document in snapshot.docChanges) {
            var data = document.doc.data() as Map<String, dynamic>;
            debugPrint("$data");
            debugPrint('Got new remote ICE candidate: $data');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      }

      return const Right(null);

    }catch(e) {
      return Left(ApiError(errorDescription: e.toString()));
    }

  }


  void registerPeerConnectionListeners() {

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      debugPrint('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      debugPrint('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      debugPrint('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      debugPrint('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      debugPrint("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }



}