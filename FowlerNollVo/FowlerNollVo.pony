use "collections"

type PrimeFieldWidths is (U32 | U64 | U128)
type ArrayLike is (String box | Array[U8] box)

primitive Offsets
  fun apply[A: PrimeFieldWidths](): A ? =>
    iftype A <: U32 then
      A(0x811C9DC5)
    elseif A <: U64 then
      A(0xCBF29CE484222325)
    elseif A <: U128 then
      A(0x6C62272E07BB014262B821756295C58D)
    else
      error
    end

primitive Primes
  fun apply[A: PrimeFieldWidths](): A ? =>
    iftype A <: U32 then
      A(16777619)
    elseif A <: U64 then
      A(1099511628211)
    elseif A <: U128 then
      A(309485009821345068724781371)
    else
      error
    end

primitive U8Array
  fun apply[A: PrimeFieldWidths](hash: A): Array[U8] ref^ ? =>
    var size: USize
    iftype A <: U32 then
      size = 4
    elseif A <: U64 then
      size = 8
    elseif A <: U128 then
      size = 16
    else
      error
    end

    var littleEndian: Array[U8] ref^ = Array[U8].init(0, size)
    for i in Range(0, size) do
      let shift =  8 * i
      iftype A <: U32 then
        littleEndian(i)? = ((hash >> shift.u32()) and 0xFF).u8()
      elseif A <: U64 then
        littleEndian(i)? = ((hash >> shift.u64()) and 0xFF).u8()
      elseif A <: U128 then
        littleEndian(i)? = ((hash >> shift.u128()) and 0xFF).u8()
      end
    end
    littleEndian

primitive FNV1a
  fun apply[A: PrimeFieldWidths](data: ArrayLike): Array[U8] ref^ ? =>
      var result:A = FNV1a.hash[A](data)?
      U8Array[A](result)?
  fun hash[A: PrimeFieldWidths](data: ArrayLike): A ? =>
    var result: A = Offsets[A]()?
    for i in Range(0, data.size()) do
      iftype A <: U32 then
        result = result xor data(i)?.u32()
        result = result * Primes[A]()?
      elseif A <: U64 then
        result = result xor data(i)?.u64()
        result = result * Primes[A]()?
      elseif A <: U128 then
        result = result xor data(i)?.u128()
        result = result * Primes[A]()?
      else
        error
      end
    end
    result

primitive FNV1
  fun apply[A: PrimeFieldWidths](data: ArrayLike): Array[U8] ref^ ? =>
    var result: A = FNV1.hash[A](data)?
    U8Array[A](result)?
  fun hash[A: PrimeFieldWidths](data: ArrayLike): A ? =>
    var result: A = Offsets[A]()?
    for i in Range(0, data.size()) do
      iftype A <: U32 then
        result = result * Primes[A]()?
        result = result xor data(i)?.u32()
      elseif A <: U64 then
        result = result * Primes[A]()?
        result = result xor data(i)?.u64()
      elseif A <: U128 then
        result = result * Primes[A]()?
        result = result xor data(i)?.u128()
      else
        error
      end
    end
    result
