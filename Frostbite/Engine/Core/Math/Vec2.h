#pragma once


namespace fb
{

struct Vec2
{
	typedef const Vec2& Vec2Ref;

	union
	{
		struct
		{
			float x, y;
		} axis;
		float data[2];
	};

	// Initializes this Vec2 to zero
	Vec2()
	: axis{0.f, 0.f}
	{
	}

	// Initializes all members of this vector with the value of in
	Vec2(float in)
		: axis{in, in}
	{
	}

	// Initializes xy
	Vec2(float inX, float inY)
		: axis{inX, inY}
	{
	}

	// Initializes vector with the values of another Vec2
	Vec2(Vec2Ref v)
		: axis(v.axis)
	{
	}

	Vec2 operator + (Vec2Ref b)
	{
		Vec2 v;
		v.axis.x = axis.x + b.axis.x;
		v.axis.y = axis.y + b.axis.y;
		return v;
	}

	Vec2 operator * (float b)
	{
		Vec2 v;
		v.axis.x = axis.x * b;
		v.axis.y = axis.y * b;
		return v;
	}

};
static_assert(sizeof(Vec2) == 0x8, "Wrong size!");

typedef Vec2::Vec2Ref Vec2Ref;

}