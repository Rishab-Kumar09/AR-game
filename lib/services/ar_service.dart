import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ARService {
  late ARSessionManager? arSessionManager;
  late ARObjectManager? arObjectManager;

  Future<Widget> buildARView() {
    return ARView(
      onARViewCreated: onARViewCreated,
      planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
    );
  }

  void onARViewCreated(
      ARSessionManager sessionManager,
      ARObjectManager objectManager,
      ARAnchorManager anchorManager,
      ARLocationManager locationManager) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager?.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: false,
      handleTaps: false,
    );
  }

  Future<void> addAnimationToWorld(
      String animationPath, Vector3 position) async {
    if (arObjectManager == null) return;

    final node = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      uri: animationPath,
      scale: Vector3(0.2, 0.2, 0.2),
      position: position,
      rotation: Vector4(1.0, 0.0, 0.0, 0.0),
    );

    await arObjectManager?.addNode(node);
  }

  void dispose() {
    arSessionManager?.dispose();
  }
}
