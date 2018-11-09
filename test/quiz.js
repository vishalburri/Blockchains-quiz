var Quiz = artifacts.require("Quiz");

// Helps in asserting events
// const truffleAssert = require("truffle-assertions");

contract("Quiz", accounts => {
	const owner = accounts[0];
	const secret = "0x285714a264559271d4d0476417a4147c560679e9221b296fa6a74041e10b9792";
	const key = [1,2,3,4];
	describe("constructor", () => {
		describe("Assert Contract is deployed", () => {
			it("should deploy this contract", async () => {
				const instance = await Quiz.new(5,60,60,60,10,secret,{ from: owner });

				let tot = await instance.totPlayers.call();
				let fee = await instance.quizFee.call();

				assert.isNotNull(instance);
				assert.equal(tot.toNumber(), 5);
				assert.equal(fee.toNumber(), 10);

				
			});
		});
		describe("Fail case", () => {
			it("should revert on invalid from address", async () => {
				try {
					const instance = await Quiz.new(5,60,60,60,10,secret ,{
						from: "lol"
					});
					assert.fail(
						"should have thrown an error in the above line"
					);
				} catch (err) {
					assert.equal(err.message, "invalid address");
				}
			});
		});
	});