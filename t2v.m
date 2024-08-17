function pose = t2v(T)
    x = T(1,3);
    y = T(2,3);
    theta = atan2(T(2,1), T(1,1));
    pose = [x; y; theta];
end

