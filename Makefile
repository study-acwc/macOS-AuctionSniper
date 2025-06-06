TUIST = mise exec tuist -- tuist
SWIFTLINT = swiftlint

# 로컬패키지 tuist cache 제외를 위한 파일
CACHE_CONFIG_PATH := Scripts/cache_config.yaml
EXCLUDE_TARGETS = $(shell yq '.exclude_targets[]' $(CACHE_CONFIG_PATH))

# 프로젝트를 여러개 clone할 때 Workspace에 구분용 Suffix 추가하기
WORKSPACE_CONFIG_PATH := Scripts/workspace_config.yaml
WORKSPACE_SUFFIX = $(shell [ -f $(WORKSPACE_CONFIG_PATH) ] && yq '.workspace_suffix' $(WORKSPACE_CONFIG_PATH))

all: lint build-dev

generate:
	@if ! command -v yq &> /dev/null; then \
		echo "yq is not installed, installing..."; \
		brew install yq; \
	fi
	$(TUIST) install
	@if [ -n "$(WORKSPACE_SUFFIX)" ]; then \
		TUIST_WORKSPACE_SUFFIX=$(WORKSPACE_SUFFIX) TUIST_ROOT_DIR=${PWD} $(TUIST) generate; \
	else \
		TUIST_ROOT_DIR=${PWD} $(TUIST) generate; \
	fi
	
	
generate-no-cache:
	$(TUIST) install
	@if [ -n "$(WORKSPACE_SUFFIX)" ]; then \
		TUIST_WORKSPACE_SUFFIX=$(WORKSPACE_SUFFIX) TUIST_ROOT_DIR=${PWD} $(TUIST) generate --no-binary-cache; \
	else \
		TUIST_ROOT_DIR=${PWD} $(TUIST) generate --no-binary-cache; \
	fi
	
cache:
	tuist clean
	@if ! command -v yq &> /dev/null; then \
		echo "yq is not installed, installing..."; \ 
		brew install yq; \
	fi
	$(TUIST) install
	$(TUIST) cache $(EXCLUDE_TARGETS) --external-only

lint:
	$(SWIFTLINT) --fix

clean:
	find . -type d -name Derived -exec rm -rf {} +
	find . -type d -name "*.xcodeproj" -exec rm -rf {} +
	find . -type d -name "*.xcworkspace" -exec rm -rf {} +

format:
	$(SWIFTLINT) autocorrect --fix
	
help:
	@echo "사용 가능한 명령어:"
	@echo "  make all               - 린트 및 dev 빌드 수행"
	@echo "  make generate          - tuist generate 수행"
	@echo "  make generate-no-cache - tuist generate 수행 (캐시 사용 안 함)"
	@echo "  make cache             - tuist 캐시 생성"
	@echo "  make lint              - 코드 린트"
	@echo "  make clean             - Tuist 생성물 모두 삭제"
	@echo "  make format            - 코드 자동 포맷팅"
	@echo "  make tuist-init        - tuist 초기 설정"
	@echo "  make help              - 사용 가능한 명령어 목록 출력"
