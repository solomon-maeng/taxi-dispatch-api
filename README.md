# 택시 배차 API

택시 배차 API는 다음의 기술들로 개발되었습니다.
- Ruby 3.1.2
- Rails 7.0.4
- Mysql 5.7

택시 배차 API는 다음의 기능들을 제공합니다.
- 회원가입
- 로그인
- 택시 배차 요청
- 택시 배차 요청 수락
- 모든 배차 목록 조회

## 실행 방법

모든 과정은 m1 pro 맥북 기준으로 한다.

ruby on rails 의존성을 추가한다.
```
$ bundle install
```

docker compose를 실행한다.
```
$ docker-compose up -d
```

실행된 Docker로 접속하여 다음의 명령어들을 순차적으로 실행한다.
```
$ mysql -u root -p -h 127.0.0.1
$ Enter Password: {Docker Compose 파일에 비밀번호 참조}
$ source {택시 배차 프로젝트의 db 디렉토리 안에 있는 structure.sql의 절대 경로}
```

다음 명령어를 실행하여, 자동화된 테스트가 성공적으로 작동하는지 확인한다.
- 51개의 테스트 케이스가 성공하면 프로젝트 설정이 완료된 것이다.
```
$ bundle exec rspec
```
