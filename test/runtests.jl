using AstroImages, FixedPointNumbers
using Base.Test

import AstroImages: _float

@testset "Conversion to float and fixed-point" begin
    @testset "Float" begin
        for T in (Float16, Float32, Float64)
            @test _float(T(-9.8)) === T(-9.8)
            @test _float(T(12.3)) === T(12.3)
        end
    end
    @testset "Unsigned integers" begin
        for (T, NT) in ((UInt8,  N0f8),
                        (UInt16, N0f16),
                        (UInt32, N0f32),
                        (UInt64, N0f64))
            @test _float(typemin(T)) === NT(0)
            @test _float(T(85)) === reinterpret(NT, T(85))
            @test _float(typemax(T)) === NT(1)
        end
    end
    @testset "Signed integers" begin
        for T in (Int8, Int16, Int32, Int64)
            N = sizeof(T) * 8
            FT = Fixed{T, N-1}
            @test _float(typemin(T)) === FT(-1)
            @test _float(T(-85))     === reinterpret(FT, T(-85))
            @test _float(T(0))       === reinterpret(FT, T(0))
            @test _float(T(115))     === reinterpret(FT, T(115))
            @test _float(typemax(T)) === FT(1 - big(2.0) ^ (1 - N))
        end
    end
end