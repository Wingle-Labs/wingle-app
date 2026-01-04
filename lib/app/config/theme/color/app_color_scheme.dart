import 'package:flutter/material.dart';

/// 애플리케이션 컬러 스키마.
///
/// 디자이너가 제공한 컬러 스키마를 1:1로 정의하는 인터페이스.
abstract interface class AppColorScheme {
  // ! Primary Color: 주요 컬러
  /// - [primary]: 강조된 UI에 사용하는 메인 색상
  /// primary 버튼 배경 등
  Color get primary;

  /// - [onPrimary]: 강조된 UI 요소 내부에 사용하는 색상
  /// primary 버튼 내부 텍스트 / 아이콘
  Color get onPrimary;

  // ! 텍스트 관련 컬러: 계층과 용도에 따른 구분
  /// - [textPrimary]: 텍스트 강조 레벨 1단계
  /// Title, Body text 등 핵심 정보 텍스트
  Color get textPrimary;

  /// - [textSecondary]: 텍스트 강조 레벨 2단계
  /// 설명 문구, 비선택 Chip 등 보조 정보 텍스트
  Color get textSecondary;

  /// - [textTertiary]: 텍스트 강조 레벨 3단계
  /// Hint, Placeholder, 메타 정보 텍스트
  Color get textTertiary;

  /// - [textDisabled]: 텍스트 강조 레벨 4단계
  /// Disabled 설명 텍스트
  /// 14px(Bold) 이상, 18px 이하에서 사용
  Color get textDisabled;

  /// - [textInactive]: 텍스트 강조 레벨 4단계
  /// 비활성 라벨 텍스트
  /// 14px(Bold) 이상, 18px 이하에서 사용
  Color get textInactive;

  /// - [textDisabledStrong]: 텍스트 강조 레벨 5단계
  /// 완전 비활성화 텍스트, 시스템 메타 정보 텍스트
  /// 명암비 2.6:1로 가시성이 떨어지는 색상
  Color get textDisabledStrong;

  // ! Surface 관련 컬러: 컨테이너 및 레이어별 배경 색상
  /// - [background]: 앱 전체의 바닥 레이어 / 움직이지 않는 레이어
  /// 앱 전체 배경, 스크롤 영역 바탕, 최외곽 영역
  Color get background;

  /// - [surface]: 실제 UI 요소가 올라가는 요소의 배경
  /// 카드 배경, 리스트 아이템, 기본 영역 컨테이너
  Color get surface;

  /// - [surfaceVariant]: Surface와 같은 위계에서 시각적 맥락만 분리된 요소의 배경
  /// 설정 화면의 그룹 영역, 카드 내부의 서브 액션, 필터 영역, 보조 정보 블록
  Color get surfaceVariant;

  /// - [surfaceElevated]: 시각적 깊이, 레이어 우선순위 표현 또는 사용자 포커스를 끌어야 하는 컨테이너의 배경
  /// Modal, Bottom Sheet, Floating Card, Tooltip
  Color get surfaceElevated;

  /// - [surfaceDisabled]: 비활성화된 UI 요소의 배경
  /// 사용자가 현재 상호작용할 수 없는 상태임을 시각적으로 표현
  Color get surfaceDisabled;

  /// - [surfaceDisabledSubtle]: 비활성화된 UI 요소의 배경의 보조
  Color get surfaceDisabledSubtle;

  // ! Feedback 컬러
  /// - [error]: 삭제 및 강력한 경고 요소
  /// error 버튼 배경 색상
  Color get error;

  /// - [onError]: 삭제 및 강력한 경고 요소 텍스트 색상
  /// error 버튼 텍스트 색상
  Color get onError;

  /// - [success]: 성공, 통과 요소
  Color get success;

  /// - [onSuccess]: 성공, 통과 요소 텍스트 색상
  Color get onSuccess;

  /// - [warning]: 가벼운 경고 요소
  Color get warning;

  /// - [onWarning]: 가벼운 경고 요소 텍스트 색상
  Color get onWarning;

  /// - [info]: 안내 색상
  Color get info;

  /// - [onInfo]: 안내 텍스트 색상
  Color get onInfo;

  /// - [cancel]: 취소, 주의 필요성 낮은 요소 색상
  /// cancel 버튼 배경 색상
  Color get cancel;

  /// - [onCancel]: 취소, 주의 필요성 낮은 요소 텍스트 색상
  /// cancel 버튼 텍스트 색상
  Color get onCancel;

  // ! 인터랙션 피드백 및 상태 표현용 오버레이 및 경계 색상
  /// - [border]: 영역 구분용 경계선 색상
  Color get border;

  /// - [divider]: 컨텐츠 흐름 구분용 구분선 색상
  Color get divider;

  /// - [scrim]: Modal 열렸을 때 배경
  /// Bottom Sheet 뒤 화면, Dialog Focus 분리
  Color get scrim;

  /// - [overlayPressed]: 누름 상태 오버레이 색상
  /// Button, Chip, Card 등 Pressed 상태
  Color get overlayPressed;

  /// - [overlayDisabled]: 비활성 상태 오버레이 색상
  /// Button, Chip, Card 등 Diasabled 상태
  Color get overlayDisabled;

  /// - [overlayLoading]: 로딩 상태 오버레이 색상
  Color get overlayLoading;

  // ! 상태 존재 버튼의 상태 표현 컬러
  // ! Chip, Radio, Checkbox, ListButton 등
  /// - [stateBtnSelected]: 상태 존재 버튼의 선택 상태 색상
  Color get stateBtnSelected;

  /// - [stateBtnUnselected]: 상태 존재 버튼의 비선택 상태 색상
  Color get stateBtnUnselected;

  /// - [stateBtnDisabled]: 상태 존재 버튼의 비활성 상태 색상
  Color get stateBtnDisabled;

  // ! 단순 버튼의 상태 표현 컬러
  // ! Filled, Outlined, Text 버튼
  /// - [btnDefault]: 단순 버튼의 활성 상태
  Color get btnDefault;

  /// - [btnDisabled]: 단순 버튼의 비활성 상태
  Color get btnDisabled;

  // ! 프로필 카드 속 입력사항 Badge 표현 컬러
  /// - [profileStatusBadgeDefault]: Badge의 활성 상태
  Color get profileStatusBadgeDefault;

  /// - [profileStatusBadgeDisabled]: Badge의 비활성 상태
  Color get profileStatusBadgeDisabled;

  // ! 디자인에서 제공하는 톤 스케일: Primary 색상 계열의 다양한 명도 단계
  /// - [primaryScale90]: 90% 명도 톤
  Color get primaryScale90;

  /// - [primaryScale70]: 70% 명도 톤
  Color get primaryScale70;

  /// - [primaryScale50]: 50% 명도 톤
  Color get primaryScale50;

  /// - [primaryScale30]: 30% 명도 톤
  Color get primaryScale30;

  /// - [primaryScale10]: 10% 명도 톤
  Color get primaryScale10;
}
