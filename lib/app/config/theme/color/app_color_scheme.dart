import 'package:flutter/material.dart';

/// 애플리케이션 컬러 스키마.
///
/// 디자이너가 제공한 컬러 스키마를 1:1로 정의하는 인터페이스.
abstract interface class AppColorScheme {
  /// 앱 전체 배경에 사용되는 기본 배경 색상.
  Color get background;

  // ! Primary Color: 주요 컬러
  /// - [primary]: 주요 컬러
  Color get primary;

  /// - [onPrimary]: 주요 컬러의 텍스트 색상
  Color get onPrimary;

  // ! 텍스트 관련 컬러: 계층과 용도에 따른 구분
  /// - [textPrimary]: 주요 텍스트 색상
  Color get textPrimary;

  /// - [textSecondary]: 보조 텍스트 색상
  Color get textSecondary;

  /// - [textTertiary]: 3차 텍스트 색상 (덜 강조된 텍스트)
  Color get textTertiary;

  /// - [textDisabled]: 비활성화된 텍스트 색상
  Color get textDisabled;

  /// - [textInactive]: 비활성 상태 텍스트 색상
  Color get textInactive;

  /// - [textDisabledStrong]: 강한 비활성 텍스트 색상
  Color get textDisabledStrong;

  /// - [textBg30]: 배경 대비 30% 텍스트 색상
  Color get textBg30;

  /// - [textBg10]: 배경 대비 10% 텍스트 색상
  Color get textBg10;

  // ! Surface 관련 컬러: 컨테이너 및 레이어별 배경 색상
  /// - [surfaceBackground]: 표면 배경 기본 색상
  Color get surfaceBackground;

  /// - [surface]: 기본 표면 색상
  Color get surface;

  /// - [surfaceVariant]: 변형된 표면 색상
  Color get surfaceVariant;

  /// - [surfaceElevated]: 상승된 표면 색상 (elevation 효과)
  Color get surfaceElevated;

  // ! 인터랙션 피드백 및 상태 표현용 오버레이 및 경계 색상
  /// - [scrimBorder]: 경계선 색상
  Color get scrimBorder;

  /// - [overlayPressed]: 누름 상태 오버레이 색상
  Color get overlayPressed;

  /// - [overlayDisabled]: 비활성 상태 오버레이 색상
  Color get overlayDisabled;

  /// - [overlayLoading]: 로딩 상태 오버레이 색상
  Color get overlayLoading;

  /// - [border]: 일반 경계선 색상
  Color get border;

  /// - [divider]: 구분선 색상
  Color get divider;

  /// - [stateDefault]: 기본 상태 색상
  Color get stateDefault;

  /// - [statePressed]: 눌림 상태 색상
  Color get statePressed;

  /// - [stateDisabled]: 비활성 상태 색상
  Color get stateDisabled;

  // ! 의미론적 피드백 컬러: 에러, 성공, 경고, 정보 상태 표현
  /// - [error]: 에러 상태 색상
  Color get error;

  /// - [onError]: 에러 텍스트 색상
  Color get onError;

  /// - [success]: 성공 상태 색상
  Color get success;

  /// - [onSuccess]: 성공 텍스트 색상
  Color get onSuccess;

  /// - [warning]: 경고 상태 색상
  Color get warning;

  /// - [onWarning]: 경고 텍스트 색상
  Color get onWarning;

  /// - [info]: 정보 상태 색상
  Color get info;

  /// - [onInfo]: 정보 텍스트 색상
  Color get onInfo;

  // ! 디자인에서 제공하는 톤 스케일: Primary 색상 계열의 다양한 명도 단계
  /// - [scalePrimary90]: 90% 명도 톤
  Color get scalePrimary90;

  /// - [scalePrimary70]: 70% 명도 톤
  Color get scalePrimary70;

  /// - [scalePrimary50]: 50% 명도 톤
  Color get scalePrimary50;

  /// - [scalePrimary30]: 30% 명도 톤
  Color get scalePrimary30;

  /// - [scalePrimary10]: 10% 명도 톤
  Color get scalePrimary10;
}
