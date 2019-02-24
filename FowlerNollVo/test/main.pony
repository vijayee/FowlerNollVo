use "ponytest"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_TestFNV1)
    test(_TestFNV1a)

class iso _TestFNV1 is UnitTest
  fun name(): String => "Testing FNV1"
  fun apply(t: TestHelper) =>
    try
      var result: U32 = FNV1.hash[U32]("hello")?
      t.assert_true(result == 3069866343)
    else
      t.assert_true(false)
    end
class iso _TestFNV1a is UnitTest
  fun name(): String => "Testing FNV1a"
  fun apply(t: TestHelper) =>
    try
      var result: U32 = FNV1a.hash[U32]("hello")?
      t.assert_true(result == 1335831723)
    else
      t.assert_true(false)
    end
