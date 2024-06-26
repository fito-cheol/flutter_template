1. env 세팅할것
   template/env
   크롬에서 실행시키는 경우 구글맵을 보려면
   index.html 파일에서
   GOOGLE_MAP_Key 값 수정하기

2. 코드 실행

```
cd template
flutter run
```

3. 배포하기 (https://whoyoung90.tistory.com/79 참고)

KeyStore 만들기

```
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

android > app 경로에 key.jks 파일
android > app key.properties 파일 생성

```
storePassword=<키생성시 입력한 암호>
keyPassword=<키생성시 입력한 암호>
keyAlias=key
storeFile=./key.jks
```

android > app > build.gradle 변경사항

```

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

...
   signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
   buildTypes {
         release {
            signingConfig signingConfigs.release
         }
   }
```

실행

```
flutter build appbundle
```
