# Validación
Desde 07_Participacion/divisor_cuenta en la rama sdd:
```powershell
flutter pub get
flutter analyze
flutter test --reporter expanded
flutter test --platform chrome --reporter expanded
flutter build apk --debug
flutter run -d chrome
```
Si Windows bloquea flutter_tester.exe, registrar el bloqueo y ejecutar la alternativa Chrome.
Comprobación de dominio sin motor:
```powershell
& 'C:\dev\flutter\flutter\bin\cache\dart-sdk\bin\dart.exe' run tool/verificar_domain.dart
```
Los seis escenarios están en spec.md y test/casos_de_prueba.dart.
100,50 y 2 personas deben dar 50.25 sin propina.
Después de un resultado válido, cero personas debe ocultarlo y mostrar el error.

