# Terraform AWS Infrastructure - my-terraform
[Build my_terraform](https://www.notion.so/adapterz/AWS-Architecture-1b2394a48061807e805dd5a3e1953b57)

![프로젝트 아키텍쳐](https://github.com/Hyunje1128/KTB_Cloud/blob/main/my-terraform.png)

> 위 아키텍처는 GitHub Actions → S3 → CodeDeploy → EC2 오토스케일링 → ALB → CloudFront → Route 53 순으로 이어지는 전체 사용자 접점 배포 흐름을 시각화한 것입니다.

## 🔧 구성 개요
이 프로젝트는 Terraform을 사용해 AWS 환경에 다음 리소스들을 자동으로 생성합니다:

- VPC (Public / Private App / Private DB Subnet)
- Internet Gateway / NAT Gateway
- ALB (Application Load Balancer)
- EC2 (Auto Scaling Group 포함)
- RDS (MySQL)
- OpenVPN 서버 (고정 EIP)
- 보안 그룹 (모듈 분리)
- # `.ovpn` 템플릿 자동 생성 구조(미완성)
- 정적 웹서버 배포 (Python HTTP Server)
- 상태 파일 원격 저장 (S3 + DynamoDB 백엔드 구성)

---

## 📁 프로젝트 디렉토리 구조

```
MY_TERRAFORM/
├── .terraform/              # Terraform 상태/캐시 디렉토리
├── app/                     # 정적 웹 앱 디렉토리 (CI/CD 대상)
│   ├── scirpts/             # 배포 후 실행할 start.sh 등 스크립트
│   │       └── start.sh/    # Python HTTP 서버 실행 스크립트
│   ├── index.html/          # 정적 웹 페이지 파일
│   └── appsepc.yml/         # CodeDeploy용 앱 스펙
├── environments/            # 환경별 인프라 구성 (dev, prod 등)
│   ├── dev/                 # 개발자(me)가 테스트할 환경
│   ├── dev-fast/            # 최소한의 리소스로 빠른 테스트 환경
│   ├── prod/                # 실제 배포 환경
│   └── stage/
├── mgmt/                    # 관리용 모듈 또는 구성 요소
├── modules/                 # 재사용 가능한 Terraform 모듈
│   ├── vpc/                 # VPC 관련 모듈
│   ├── alb/                 # Auto Scaling을 위한 로드발런서 모듈
│   ├── ec2/                 # 시작템플릿 및 ec2와 관련된 모듈
│   ├── rds/                 # db 관리를 위한 rds 모듈
│   ├── security/            # 보안그룹 모듈 구성
│   ├── codedeploy/          # CodeDeploy 배포 모듈
│   ├── iam/                 # GitHub 액세스용 IAM 모듈
│   ├── s3/                  # 배포용 S3 버킷 모듈
│   ├── acm/                 # SSL 인증서(AWS Certificate Manager) 모듈
│   ├── cloudfront/          # CloudFront 구성 모듈
│   └── route53/             # Route 53 도메인 및 레코드 모듈
├── scripts/                 # 초기화 스크립트 및 자동화 스크립트
├── templates/               # 템플릿 파일 (.tpl 등)
├── .gitignore
├── architecture_flow.html  # 인프라 아키텍처 흐름 문서 (시각화)
├── backend.tf              # 원격 상태 저장소 설정
├── main.tf                 # 루트 Terraform 엔트리포인트
├── Makefile                # Terraform 작업 자동화를 위한 명령 정의
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
| `modules/iam` | GitHub Actions에서 사용할 IAM 사용자 및 정책 구성 |
| `modules/s3` | GitHub Actions 배포 아티팩트 저장용 S3 버킷 |

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
## 📦 상태 파일 관리 (S3 + DynamoDB Backend 구성)

Terraform 협업을 위한 상태 관리 구성을 포함하고 있습니다:

- terraform.tfstate는 S3 버킷에 저장되어 팀원 간 상태 공유

- DynamoDB를 통해 상태 잠금(Locking) 적용하여 동시 실행 충돌 방지

#### 🔧 Backend 설정 예시 (backend.tf)

terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

> ✅ S3 버킷과 DynamoDB 테이블은 별도 Terraform 모듈로 구성 가능하며, environments/dev 내 backend.tf로 각 환경별 상태를 분리 관리합니다.
---

## 🧪 개발 진행 현황

### ✅ 완료

- Terraform 기반 모듈 구성 및 배포 자동화
- OpenVPN EC2 서버 및 고정 EIP 연결
- RDS (MySQL) Private Subnet 배포
- 인증서 수동 발급 및 VPN 연결 테스트 포기 -> 추후 고도화
  - 지금은 ec2에 ami 이미지로 웹 콘솔에서 profile 다운으로 연결 
- CodeDeploy / IAM / S3 기반 CI/CD 인프라 구성
- GitHub Actions workflow 파일 작성
- EC2 CodeDeploy Agent 설치 및 앱 배포 테스트
- **정적 웹 서버를 EC2에 배포하고 ALB를 통해 접근 가능하도록 구성**
  - Python HTTP 서버 실행
  - ALB Target Group 설정 및 정상 상태 확인
  - Nginx 제거 후 수동 서버 실행으로 502 오류 해결 -> 같은 80포트를 쓰기 때문
- ALB 오리진을 통해 CloudFront에서 유저에게 배포 확인

### ⏳ 진행 중

- `.ovpn` 자동 생성 (templatefile + output 연동)
- 인증서 자동 발급 스크립트 구성
- 환경별 `.tfvars` 분리 및 리팩토링
- 상태 파일 백엔드 구성 (S3 + DynamoDB) 완료
- CloudFront + Route 53 구성 및 유저 접근 경로 실제 배포 적용
  - 등록된 도메인(rok-lee.com)으로 호스팅 구성 진행 중

---

## 📋 To-Do List

| 상태 | 항목 |
|------|------|
| ✅ | VPC 모듈 보완 (IGW, NAT, RT 포함) |
| ✅ | EC2 + Auto Scaling Group 모듈 |
| ✅ | EC2 보안 그룹 모듈 분리 |
| ✅ | RDS 모듈 (Private Subnet) |
| ✅ | OpenVPN 모듈 (고정 IP 포함) |
| ✅ | OpenVPN ec2 접속 후 vpn이미지를 통한 vpn접속 |
| ✅ | CodeDeploy App, Group 구성 |
| ✅ | GitHub IAM 사용자 구성 |
| ✅ | S3 배포 버킷 생성 |
| ✅ | 정적 웹 서버 수동 배포 및 ALB 연동 테스트 |
| ✅ | GitHub Actions Workflow 구성 |
| ✅ | CodeDeploy Agent 설치 (EC2) |
| ✅ | appspec.yml, 배포 스크립트 구성 |
| ✅ | Python HTTP 서버 실행 자동화 (start.sh / user_data 등) |
| ✅ | CloudFront + Route53 도입 및 유저 접근 최적화 |
| ⏳ | 등록된 도메인(rok-lee.com)으로 호스팅 구성 |
| ⏳ | 상태 파일 백엔드 구성 (S3 + DynamoDB) |

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
