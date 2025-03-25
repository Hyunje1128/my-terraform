# Makefile

# 변수
ENV_DIR=environments/dev
CERT_SCRIPT=scripts/fetch_certs.sh
OVPN_SCRIPT=scripts/generate_ovpn.sh
OVPN_OUTPUT=client1.ovpn
KEY_PATH=~/my_terraform/my-terraform-key.pem
TARGET=

.PHONY: all apply destroy output certs ovpn refresh ssh target destroy-target

# 전체 수행
all: apply ovpn

# Terraform Apply
apply:
	@echo "🔨 Terraform Apply 시작..."
	cd $(ENV_DIR) && terraform apply -auto-approve

# Terraform Destroy
destroy:
	@echo "💣 Terraform Destroy 시작..."
	cd $(ENV_DIR) && terraform destroy -auto-approve

# Output 확인
output:
	cd $(ENV_DIR) && terraform output

# 인증서 가져오기
certs:
	@echo "📦 인증서 가져오기..."
	bash $(CERT_SCRIPT)

# .ovpn 파일 생성
ovpn:
	@echo "🔧 .ovpn 생성 중..."
	bash $(OVPN_SCRIPT)

# 상태 갱신
refresh:
	cd $(ENV_DIR) && terraform apply -refresh-only

# EC2 SSH 접속
ssh:
	@echo "🔐 SSH 접속: $(EC2_IP)"
	ssh -i $(KEY_PATH) ec2-user@$(EC2_IP)

# 특정 리소스만 apply
target:
ifndef TARGET
	$(error ❌ TARGET 변수가 필요합니다. 예: make target TARGET=module.openvpn)
endif
	@echo "🎯 Terraform apply -target=$(TARGET)"
	cd $(ENV_DIR) && terraform apply -target=$(TARGET) -auto-approve

# 특정 리소스만 destroy
destroy-target:
ifndef TARGET
	$(error ❌ TARGET 변수가 필요합니다. 예: make destroy-target TARGET=module.openvpn)
endif
	@echo "💥 Terraform destroy -target=$(TARGET)"
	cd $(ENV_DIR) && terraform destroy -target=$(TARGET) -auto-approve