import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_mate/presentation/bloc/auth/auth_bloc.dart';
import 'package:money_mate/presentation/pages/auth/register_page.dart';

import 'register_page_test.mocks.dart';

@GenerateMocks([AuthBloc])
void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    
    // Thiết lập trạng thái mặc định
    when(mockAuthBloc.state).thenReturn(AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(AuthInitial()));
  });

  Widget createTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const RegisterPageView(),
      ),
    );
  }

  testWidgets('RegisterPageView hiển thị tất cả các phần tử UI cần thiết', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Kiểm tra các widget chính được hiển thị
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('REGISTER'), findsOneWidget);
    expect(find.text('ĐĂNG KÝ VỚI GOOGLE'), findsOneWidget);
    expect(find.text('ĐĂNG KÝ VỚI APPLE'), findsOneWidget);
    expect(find.text('Đã có tài khoản?'), findsOneWidget);
    expect(find.text('Đăng nhập ngay'), findsOneWidget);
  });

  testWidgets('Hiển thị lỗi khi nhấn submit mà không điền thông tin', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Nhấn vào nút REGISTER mà không điền thông tin
    await tester.tap(find.text('REGISTER'));
    await tester.pump();

    // Kiểm tra thông báo lỗi xuất hiện
    expect(find.text('Vui lòng điền đầy đủ thông tin'), findsOneWidget);
  });

  testWidgets('Hiển thị lỗi khi mật khẩu không khớp', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Điền thông tin đăng ký với mật khẩu không khớp
    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password456');
    
    // Nhấn đăng ký
    await tester.tap(find.text('REGISTER'));
    await tester.pump();

    // Kiểm tra thông báo lỗi xuất hiện
    expect(find.text('Mật khẩu nhập lại không khớp'), findsOneWidget);
  });

  testWidgets('Hiển thị lỗi khi định dạng email không hợp lệ', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Điền thông tin đăng ký với email không hợp lệ
    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'invalid-email');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password123');
    
    // Nhấn đăng ký
    await tester.tap(find.text('REGISTER'));
    await tester.pump();

    // Kiểm tra thông báo lỗi xuất hiện
    expect(find.text('Email không hợp lệ'), findsOneWidget);
  });

  testWidgets('Gọi AuthBloc khi form hợp lệ', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget());

    // Điền thông tin đăng ký hợp lệ
    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'password123');
    
    // Nhấn đăng ký
    await tester.tap(find.text('REGISTER'));
    await tester.pump();

    // Verify AuthBloc được gọi với sự kiện RegisterWithEmailEvent
    verify(mockAuthBloc.add(any)).called(1);
  });
} 