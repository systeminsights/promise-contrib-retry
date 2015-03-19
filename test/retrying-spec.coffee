B = require 'bluebird'
{both, constant, limit} = require 'retry-policy'
retrying = require '../src/index'

describe "retrying", ->
  it "should return the original result when promise resolves", ->
    expect(retrying(constant(50), -> B.resolve(5))).to.become(5)

  it "should be resolved when the function eventually resolves", ->
    ct = 3
    f = -> if (ct--) == 0 then B.resolve(10) else B.reject("REJECTED")
    expect(retrying(constant(50), f)).to.become(10)

  it "should be rejected when the policy halts", ->
    pol = both(constant(50), limit(4))
    expect(retrying(pol, (-> B.reject("FAILED")))).to.be.rejectedWith("FAILED")

