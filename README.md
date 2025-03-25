# Terraform AWS Infrastructure - my-terraform

![프로젝트 아키텍쳐](https://github.com/Hyunje1128/KTB_Cloud/blob/main/Architecture_v3.png)

## 🔧 구성 개요
이 프로젝트는 Terraform을 사용해 AWS 환경에 다음 리소스들을 자동으로 생성합니다:

- VPC (Public / Private App / Private DB Subnet)
- Internet Gateway / NAT Gateway
- ALB (Application Load Balancer)
- EC2 (Auto Scaling Group 포함)
- RDS (MySQL)
- OpenVPN 서버 (고정 EIP)
- 보안 그룹 (모듈 분리)
- `.ovpn` 템플릿 자동 생성 구조

---

## 📁 프로젝트 디렉토리 구조

```
MY_TERRAFORM/
├── .terraform/              # Terraform 상태/캐시 디렉토리
├── certs/                   # 인증서(.crt, .key 등) 저장 위치
├── environments/            # 환경별 인프라 구성 (dev, prod 등)
│   ├── dev/
│   ├── dev-fast/
│   ├── prod/
│   └── stage/
├── mgmt/                    # 관리용 모듈 또는 구성 요소
├── modules/                 # 재사용 가능한 Terraform 모듈
│   ├── openvpn/             # OpenVPN Access Server 모듈
│   ├── codedeploy/          # CodeDeploy 배포 모듈
│   ├── iam/
│   │   └── github/          # GitHub 액세스용 IAM 모듈
│   └── s3/
│       └── artifact/       # 배포용 S3 버킷 모듈
├── scripts/                 # 초기화 스크립트 및 자동화 스크립트
├── templates/               # 템플릿 파일 (.tpl 등)
├── .gitignore
├── architecture_flow.html  # 인프라 아키텍처 흐름 문서 (시각화)
├── backend.tf              # 원격 상태 저장소 설정
├── client1.ovpn            # OpenVPN 클라이언트 구성 파일
├── main.tf                 # 루트 Terraform 엔트리포인트
├── Makefile                # Terraform 작업 자동화를 위한 명령 정의
├── my-terraform-key.pem    # SSH 키 (비밀키, 절대 공개 금지)
├── outputs.tf              # 출력 변수 정의
├── provider.tf             # 프로바이더(AWS 등) 설정
├── README.md               # 프로젝트 설명 문서
└── variables.tf            # 전역 변수 정의
```

> ✅ 모든 환경은 `environments/` 디렉토리에서 개별적으로 관리되며, 공통 모듈은 `modules/`에서 참조합니다.

---

## 🚀 CI/CD 구성 모듈 요약

| 모듈 경로 | 설명 |
|-----------|------|
| `modules/codedeploy/` | CodeDeploy App 및 Deployment Group 생성 |
| `modules/iam/github/` | GitHub Actions에서 사용할 IAM 사용자 및 정책 구성 |
| `modules/s3/artifact/` | GitHub Actions 배포 아티팩트 저장용 S3 버킷 |

#### 🔐 GitHub Secrets 등록 필요

| 키 | 설명 |
|----|------|
| `AWS_ACCESS_KEY_ID` | GitHub IAM 사용자 키 |
| `AWS_SECRET_ACCESS_KEY` | GitHub IAM 사용자 시크릿 |
| `AWS_S3_BUCKET` | 배포 대상 버킷 이름 |
| `AWS_REGION` | ex. `ap-northeast-2` |
| `CODEDEPLOY_APP_NAME` | 배포 App 이름 |
| `CODEDEPLOY_DEPLOYMENT_GROUP` | 배포 그룹 이름 |

---

## 🧪 개발 진행 현황

### ✅ 완료

- Terraform 기반 모듈 구성 및 배포 자동화
- OpenVPN EC2 서버 및 고정 EIP 연결
- RDS (MySQL) Private Subnet 배포
- 인증서 수동 발급 및 VPN 연결 테스트 완료
- CodeDeploy / IAM / S3 기반 CI/CD 인프라 구성

### ⏳ 진행 중

- `.ovpn` 자동 생성 (templatefile + output 연동)
- 인증서 자동 발급 스크립트 구성
- 환경별 `.tfvars` 분리 및 리팩토링
- GitHub Actions workflow 파일 작성
- EC2 CodeDeploy Agent 설치 및 앱 배포 테스트

---

## 📋 To-Do List

| 상태 | 항목 |
|------|------|
| ✅ | VPC 모듈 보완 (IGW, NAT, RT 포함) |
| ✅ | EC2 + Auto Scaling Group 모듈 |
| ✅ | EC2 보안 그룹 모듈 분리 |
| ✅ | RDS 모듈 (Private Subnet) |
| ✅ | OpenVPN 모듈 (고정 IP 포함) |
| ✅ | .ovpn 템플릿 자동 생성 구조 구성 |
| ✅ | CodeDeploy App, Group 구성 |
| ✅ | GitHub IAM 사용자 구성 |
| ✅ | S3 배포 버킷 생성 |
| ⏳ | GitHub Actions Workflow 구성 |
| ⏳ | CodeDeploy Agent 설치 (EC2) |
| ⏳ | appspec.yml, 배포 스크립트 구성 |

---

## 🚀 적용 명령

```bash
cd environments/dev
terraform init
terraform apply
```

> `.ovpn` 파일은 output을 통해 자동 생성될 수 있도록 구성 중입니다.

---

## 🙌 기여 및 문의
개선 아이디어, 모듈화 제안 등 언제든 환영합니다.
