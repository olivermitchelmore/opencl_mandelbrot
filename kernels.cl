void kernel process(__write_only image2d_t out) {
    float x = (float)get_global_id(0);
    float y = (float)get_global_id(1);
    float w = (float)get_global_size(0);
    float h = (float)get_global_size(1);

    float norm_x = ((x / w) * 4 - 2) * (w / h);
    float norm_y = (y / h) * 4 - 2;

    float x1 = 0, y1 = 0;
    int iteration = 0;
    int max_iteration = 1000;

    while (x1 * x1 + y1 * y1 <= 4 && iteration < max_iteration) {
        float temp = x1 * x1 - y1 * y1 + norm_x;
        y1 = 2 * x1 * y1 + norm_y;
        x1 = temp;
        iteration++;
    }

    int2 pos = (int2)(x, y);

    if (iteration == max_iteration) {
        write_imageui(out, pos, (uint4)(0, 0, 0, 255));
    }

    else {
            write_imageui(out, pos, (uint4)((float)((iteration % 6) * 32 + 128),
                                            (float)((iteration % 4) * 10),
                                            (float)((iteration % 2) * 16 + 128), 255));
    }

}