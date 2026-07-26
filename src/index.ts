/**
 * Erdős Problem #979 Solver & Computational Study
 * 
 * f_k(n) = |{ (p_1, ..., p_k) : p_i are prime, n = p_1^k + ... + p_k^k }|
 * Investigates whether limsup f_k(n) = infinity for k >= 2.
 */

export interface ErdosSearchResult {
	k: number;
	maxPrime: number;
	totalPrimes: number;
	maxCount: number;
	maxN: number;
	collisionsCount: number;
	distribution: Record<number, number>;
}

export function isPrime(n: number): boolean {
	if (n < 2) return false;
	if (n === 2 || n === 3) return true;
	if (n % 2 === 0 || n % 3 === 0) return false;
	for (let i = 5; i * i <= n; i += 6) {
		if (n % i === 0 || n % (i + 2) === 0) return false;
	}
	return true;
}

export function getPrimesUpTo(limit: number): number[] {
	const primes: number[] = [];
	for (let i = 2; i <= limit; i++) {
		if (isPrime(i)) primes.push(i);
	}
	return primes;
}

/**
 * Solves Erdős Problem #979 representation count f_k(n) for given k and max prime limit.
 */
export function solveErdos979(k: number, maxPrime: number): ErdosSearchResult {
	const primes = getPrimesUpTo(maxPrime);
	const counts = new Map<number, number>();

	if (k === 2) {
		for (let i = 0; i < primes.length; i++) {
			const p1 = primes[i]!;
			const sq1 = p1 * p1;
			for (let j = i; j < primes.length; j++) {
				const p2 = primes[j]!;
				const n = sq1 + p2 * p2;
				counts.set(n, (counts.get(n) ?? 0) + 1);
			}
		}
	} else if (k === 3) {
		for (let i = 0; i < primes.length; i++) {
			const p1 = primes[i]!;
			const cb1 = p1 ** 3;
			for (let j = i; j < primes.length; j++) {
				const p2 = primes[j]!;
				const cb2 = cb1 + p2 ** 3;
				for (let m = j; m < primes.length; m++) {
					const p3 = primes[m]!;
					const n = cb2 + p3 ** 3;
					counts.set(n, (counts.get(n) ?? 0) + 1);
				}
			}
		}
	} else if (k === 4) {
		for (let i = 0; i < primes.length; i++) {
			const p1 = primes[i]!;
			const q1 = p1 ** 4;
			for (let j = i; j < primes.length; j++) {
				const p2 = primes[j]!;
				const q2 = q1 + p2 ** 4;
				for (let m = j; m < primes.length; m++) {
					const p3 = primes[m]!;
					const q3 = q2 + p3 ** 4;
					for (let r = m; r < primes.length; r++) {
						const p4 = primes[r]!;
						const n = q3 + p4 ** 4;
						counts.set(n, (counts.get(n) ?? 0) + 1);
					}
				}
			}
		}
	} else {
		throw new Error("k > 4 not supported in default JS search (use C++ runner)");
	}

	let maxCount = 0;
	let maxN = 0;
	let collisionsCount = 0;
	const distribution: Record<number, number> = {};

	for (const [n, count] of counts.entries()) {
		distribution[count] = (distribution[count] ?? 0) + 1;
		if (count > 1) collisionsCount++;
		if (count > maxCount) {
			maxCount = count;
			maxN = n;
		}
	}

	return {
		k,
		maxPrime,
		totalPrimes: primes.length,
		maxCount,
		maxN,
		collisionsCount,
		distribution,
	};
}

// CLI runner
if (import.meta.main) {
	console.log("=== Erdős Problem #979 Computational Search ===");
	
	const res2 = solveErdos979(2, 300);
	console.log(`\nk = 2 (Primes <= 300): Max f_2(n) = ${res2.maxCount} at n = ${res2.maxN}`);
	
	const res3 = solveErdos979(3, 80);
	console.log(`k = 3 (Primes <= 80):  Max f_3(n) = ${res3.maxCount} at n = ${res3.maxN}`);

	const res4 = solveErdos979(4, 30);
	console.log(`k = 4 (Primes <= 30):  Max f_4(n) = ${res4.maxCount} at n = ${res4.maxN}`);
}
