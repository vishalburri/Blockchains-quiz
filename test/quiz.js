var Quiz = artifacts.require("Quiz");


contract("Quiz", accounts => {
	const owner = accounts[0];
	describe("constructor", () => {
		describe("Assert Contract is deployed", () => {
			it("should deploy this contract", async () => {

				const instance = await Quiz.new(10,{ from: owner });
				let fee = await instance.joinFee.call();
				assert.equal(fee.toNumber(), 10);

				
			});
		});
		describe("Fail case", () => {
			it("should revert on invalid from address", async () => {
				try {
					const instance = await Quiz.new(10,{
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
	describe("JoinGame", () => {
		let instance;

		beforeEach(async () => {
			instance = await Quiz.new(10,{ from: owner });
		});
		
		describe("Success case", () => {
			it("2 player registers", async () => {
				await instance.joinGame({ from: accounts[1],value:10 });
				await instance.joinGame({ from: accounts[2],value:10 });
			});
		});
		describe("Fail case", () => {
			it("3 players trying to register", async () => {
				try {
				await instance.joinGame({ from: accounts[1],value:10 });
				await instance.joinGame({ from: accounts[2],value:10 });
				await instance.joinGame({ from: accounts[3],value:10 });
				} catch (err) {
					assert.equal(err.message, "VM Exception while processing transaction: revert");
				}
			});
		});
		describe("Fail case", () => {
			it("join fee insufficient", async () => {
				try {
				await instance.joinGame({ from: accounts[1],value:5 });
				} catch (err) {
					assert.equal(err.message, "VM Exception while processing transaction: revert");
				}
			});
		});
	});
	describe("Start Game", () => {
		let instance;

		beforeEach(async () => {
			instance = await Quiz.new(10,{ from: owner });
			await instance.joinGame({ from: accounts[1],value:10 });
			await instance.joinGame({ from: accounts[2],value:10 });
		});
		
		describe("Success case", () => {
			it("owner starts game", async () => {
				await instance.startGame({ from: owner});
			});
		});
		describe("Fail case", () => {
			it("players trying to start without owner approval", async () => {
				try {
				await instance.playGame(1,{ from:accounts[1]});
				} catch (err) {
					assert.equal(err.message, "VM Exception while processing transaction: revert");
				}
			});
		});
		
	});
	describe("Play Game", () => {
		let instance;

		beforeEach(async () => {
			instance = await Quiz.new(10,{ from: owner });
			await instance.joinGame({ from: accounts[1],value:10 });
			await instance.joinGame({ from: accounts[2],value:10 });
			await instance.startGame({ from: owner});
		});
		
		describe("Success case", () => {
			it("Plays game", async () => {
				await instance.playGame(1,{ from:accounts[1]});
				await instance.playGame(4,{ from:accounts[2]});
				await instance.playGame(2,{ from:accounts[1]});
				await instance.playGame(5,{ from:accounts[2]});
				await instance.playGame(3,{ from:accounts[1]});
			});
		});
		describe("Fail case", () => {
			it("Invalid move", async () => {
				try {
					await instance.playGame(0,{ from:accounts[1]});
				} catch (err) {
					assert.equal(err.message, "VM Exception while processing transaction: revert");
				}
			});
		});
		describe("Fail case", () => {
			it("Invalid Player", async () => {
				try {
					await instance.playGame(1,{ from:accounts[3]});
				} catch (err) {
					assert.equal(err.message, "VM Exception while processing transaction: revert");
				}
			});
		});
		describe("Fail case", () => {
			it("Invalid Player turn", async () => {
				try {
					await instance.playGame(1,{ from:accounts[2]});
				} catch (err) {
					assert.equal(err.message, "VM Exception while processing transaction: revert");
				}
			});
		});
	});
	describe("Get Winner", () => {
		let instance;

		beforeEach(async () => {
			instance = await Quiz.new(10,{ from: owner });
			await instance.joinGame({ from: accounts[1],value:10 });
			await instance.joinGame({ from: accounts[2],value:10 });
			await instance.startGame({ from: owner});
			await instance.playGame(1,{ from:accounts[1]});
			await instance.playGame(4,{ from:accounts[2]});
			await instance.playGame(2,{ from:accounts[1]});
			await instance.playGame(5,{ from:accounts[2]});
			await instance.playGame(3,{ from:accounts[1]});
		});
		
		describe("Success case", () => {
			it("winner is player 1", async () => {
				let winner = await instance.winner.call();
				assert.equal(winner.toNumber(), 1);
			});
		});
		describe("Fail case", () => {
			it("Winner is not player 2", async () => {
				try {
				let winner = await instance.winner.call();
				assert.equal(winner.toNumber(), 2);
				} catch (err) {
					assert.equal(err.message, "expected 1 to equal 2");
				}
			});
		});
	});
});