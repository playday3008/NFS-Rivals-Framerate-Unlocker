# Dependencies
include(FetchContent)

FetchContent_Declare(
  minhook
  GIT_REPOSITORY https://github.com/TsudaKageyu/minhook.git
  GIT_TAG c1a7c3843bd1a5fe3eb779b64c0d823bca3dc339
)
FetchContent_MakeAvailable(minhook)

FetchContent_Declare(
  Zydis
  GIT_REPOSITORY https://github.com/zyantific/zydis.git
  GIT_TAG v4.1.0
)
FetchContent_MakeAvailable(Zydis)

FetchContent_Declare(
  safetyhook
  GIT_REPOSITORY https://github.com/cursey/safetyhook.git
  GIT_TAG v0.5.3
)
FetchContent_MakeAvailable(safetyhook)
