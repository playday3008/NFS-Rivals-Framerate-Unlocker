#pragma once
#include <Engine/Core/Reflection/DataContainer.h>
#include <Engine/Core/Reflection/String.h>


namespace fb
{

class GameDataContainer : public DataContainer
{
};

class DataBusPeer : public GameDataContainer
{
protected:
	uint m_flags alignas(8);
};

class Asset : public DataContainer
{
protected:
	String m_name;
};

}