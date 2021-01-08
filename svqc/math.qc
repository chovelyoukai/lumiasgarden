float dotProduct(vector u, vector v)
{
	return (u_x * v_x) + (u_y * v_y) + (u_z * v_z);
}

vector proj(vector u, vector v)
{
	return (dotProduct(u, v) / dotProduct(v, v)) * v;
}
