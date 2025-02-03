#pragma once
#include "Vec4.h"


namespace fb
{

struct LinearTransform;

struct Quat
{
	typedef const Quat& QuatRef;

	Vec4 vec;

	Quat()
		: vec(vecUnitW())
	{
	}

	Quat(Vec4Ref v)
		: vec(v)
	{
	}

	Quat(float x, float y, float z, float w)
	{
		vec.axis.x = x;
		vec.axis.y = y;
		vec.axis.z = z;
		vec.axis.w = w;
	}

	Quat(Vec3Ref axis, float radians);
	Quat(const LinearTransform& t);

};

typedef Quat::QuatRef QuatRef;



}

#include "SSE/Quat_SSE.inl"
