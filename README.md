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

## 📁 디렉토리 구조

```
my_terraform/
├── modules/
│   ├── vpc/
│   ├── alb/
│   ├── ec2/
│   ├── rds/
│   ├── openvpn/
│   └── security/
├── environments/
│   └── dev/
│       └── main.tf
├── scripts/
│   └── openvpn_userdata.sh
├── templates/
│   └── client.ovpn.tpl
├── certs/
│   ├── ca.crt
│   ├── client1.crt
│   ├── client1.key
│   └── ta.key
└── my-terraform-key.pem
```

---

## 🧪 개발 진행 현황

### ✅ 완료

- Terraform 기반 모듈 구성 및 배포 자동화
- OpenVPN EC2 서버 및 고정 EIP 연결
- RDS (MySQL) Private Subnet 배포
- 인증서 수동 발급 및 VPN 연결 테스트 완료

### ⏳ 진행 중

- `.ovpn` 자동 생성 (templatefile + output 연동)
- 인증서 자동 발급 스크립트 구성
- 환경별 `.tfvars` 분리 및 리팩토링

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
| ⏳ | client 인증서 자동 발급 구성 |
| ⏳ | 환경 구성 보완 (prod, tfvars 등) |
| ⏳ | Remote backend (S3 + DynamoDB) |
| ⏳ | CodeDeploy / CodePipeline 모듈 구성 |

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
