import { describe, expect, test } from "bun:test";
import { isPrime, getPrimesUpTo, solveErdos979 } from "../src/index.js";

describe("erdos-979-solver", () => {
	test("primality test is correct", () => {
		expect(isPrime(2)).toBe(true);
		expect(isPrime(3)).toBe(true);
		expect(isPrime(4)).toBe(false);
		expect(isPrime(13)).toBe(true);
		expect(isPrime(100)).toBe(false);
	});

	test("primes up to 20 count is 8", () => {
		const primes = getPrimesUpTo(20);
		expect(primes).toEqual([2, 3, 5, 7, 11, 13, 17, 19]);
	});

	test("computes f_2(n) collisions for k=2", () => {
		const res = solveErdos979(2, 50);
		expect(res.maxCount).toBeGreaterThanOrEqual(2);
		expect(res.totalPrimes).toBe(15);
	});

	test("computes f_3(n) collisions for k=3", () => {
		const res = solveErdos979(3, 40);
		expect(res.maxCount).toBeGreaterThanOrEqual(1);
		expect(res.totalPrimes).toBe(12);
	});
});
