#include <vx_spawn.h>
#include "common.h"

void kernel_body(kernel_arg_t* __UNIFORM__ arg) {
	auto A = reinterpret_cast<TYPE*>(arg->A_addr);
	auto B = reinterpret_cast<TYPE*>(arg->B_addr);
	auto C = reinterpret_cast<TYPE*>(arg->C_addr);

    int size = arg->size;
    int tile_size = arg->tile_size;

    int bx = blockIdx.x; int tx = threadIdx.x;
    int by = blockIdx.y; int ty = threadIdx.y;
    int g_col = bx * blockDim.x + tx;
    int g_row = by * blockDim.y + ty;

    int sum = 0;
    for (int i = 0; i < size; i += tile_size) {
        int a = A[g_row*size + tx + i];
        int b = B[(ty + i)*size + g_col];
        int res = vx_mult_2_warp_matrix(a,b);
        sum += res;
    }
    C[g_row*size + g_col] = sum;
}

int main() {
	kernel_arg_t* arg = (kernel_arg_t*)csr_read(VX_CSR_MSCRATCH);
	return vx_spawn_threads(2, arg->grid_dim, arg->block_dim, (vx_kernel_func_cb)kernel_body, arg);
}
