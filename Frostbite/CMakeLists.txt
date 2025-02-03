# Create static library for Frostbite code
add_library(
  FrostbiteEngine
  STATIC
    Engine/Core/Math/LinearTransform.cpp
    Engine/Core/Math/Vec.cpp 
    Engine/Core/Math/Vec3.cpp
    Engine/Core/Memory/MemoryArena.cpp
    Engine/Entity/MiscEntities.cpp
    Engine/Entity/UpdateManager.cpp
    Engine/Game/Common/Gameplay/Camera/CameraManager.cpp
    Engine/Physics/Vehicle/EAGR/WheelNFS.cpp
    Extension/Cinebot/CinebotCamera.cpp
    External/EA/EAAudioCore/source/plugins/GinsuPlayer.cpp
    Race/Client/UI/Entities/Screen/ClientUIScreenEffectEntity.cpp
    Race/Client/Vehicle/Components/ClientAnimatedDriverComponent.cpp
    Race/Client/Vehicle/Components/ClientAnimationComponent.cpp
    Race/Client/Vehicle/Components/ClientFxComponent.cpp
    Race/Client/Vehicle/Components/ClientRaceLightComponent.cpp
    Race/Client/Vehicle/Components/ClientRaceVehicleComponent.cpp
    Race/Client/Weapon/ClientVehicleWeaponEntity.cpp
    Race/Common/Core/Proxy/ProxyPropertyWriter.cpp
)

target_include_directories(
  FrostbiteEngine
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/External/EA/EAAudioCore/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../util
)

target_link_libraries(
  FrostbiteEngine
  PRIVATE
    minhook
    safetyhook
)
