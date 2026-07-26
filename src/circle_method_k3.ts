/**
 * Theoretical Hardy-Littlewood Singular Series Analyzer for k=3
 * Erdős Problem #979: n = p_1^3 + p_2^3 + p_3^3
 */

function gcd(a: number, b: number): number {
	while (b !== 0) {
		const t = b;
		b = a % b;
		a = t;
	}
	return a;
}

function phi(q: number): number {
	let result = q;
	let p = 2;
	let temp = q;
	while (p * p <= temp) {
		if (temp % p === 0) {
			while (temp % p === 0) temp /= p;
			result -= Math.floor(result / p);
		}
		p++;
	}
	if (temp > 1) result -= Math.floor(result / temp);
	return result;
}

// Cubic exponential sum S_3(a, q)
function computeCubicExponentialSum(a: number, q: number): { real: number; imag: number } {
	let re = 0;
	let im = 0;
	for (let h = 1; h <= q; h++) {
		if (gcd(h, q) === 1) {
			const cube = (h * h * h) % q;
			const angle = (2 * Math.PI * a * cube) / q;
			re += Math.cos(angle);
			im += Math.sin(angle);
		}
	}
	return { real: re, imag: im };
}

// A_q(n) term in Singular Series S_3(n)
function computeAq3(q: number, n: number): number {
	const phiQ = phi(q);
	const factor = 1 / (phiQ ** 3);
	let sum = 0;

	for (let a = 1; a < q; a++) {
		if (gcd(a, q) === 1) {
			const S = computeCubicExponentialSum(a, q);
			// S^3 in complex arithmetic
			// (re + i*im)^3 = re^3 - 3*re*im^2 + i*(3*re^2*im - im^3)
			const S3Re = S.real ** 3 - 3 * S.real * (S.imag ** 2);
			const S3Im = 3 * (S.real ** 2) * S.imag - S.imag ** 3;

			// e(-a * n / q)
			const angle = (-2 * Math.PI * a * n) / q;
			const eRe = Math.cos(angle);
			const eIm = Math.sin(angle);

			const term = S3Re * eRe - S3Im * eIm;
			sum += term;
		}
	}
	return factor * sum;
}

export function computeSingularSeriesK3(n: number, maxQ: number = 30): number {
	let S3 = 1.0;
	for (let q = 2; q <= maxQ; q++) {
		S3 += computeAq3(q, n);
	}
	return S3;
}

if (import.meta.main) {
	console.log("=========================================================================");
	console.log("  HARDY-LITTLEWOOD CIRCLE METHOD: SINGULAR SERIES S_3(n) ANALYZER (k=3)");
	console.log("=========================================================================\n");

	const stijnRecord = 10588881419; // f_3 = 5 record
	const record2 = 13604651997;    // f_3 = 5 record
	const repoRecord = 999979163;    // f_3 = 4 record

	console.log(`Evaluating StijnC Record n = ${stijnRecord} (f_3 = 5):`);
	console.log(`  S_3(10,588,881,419) ≈ ${computeSingularSeriesK3(stijnRecord, 40).toFixed(4)}`);

	console.log(`\nEvaluating Second Record n = ${record2} (f_3 = 5):`);
	console.log(`  S_3(13,604,651,997) ≈ ${computeSingularSeriesK3(record2, 40).toFixed(4)}`);

	console.log(`\nEvaluating Repo Record n = ${repoRecord} (f_3 = 4):`);
	console.log(`  S_3(999,979,163)     ≈ ${computeSingularSeriesK3(repoRecord, 40).toFixed(4)}`);

	console.log(`\nEvaluating Non-record n = 10000000000:`);
	console.log(`  S_3(10,000,000,000)  ≈ ${computeSingularSeriesK3(10000000000, 40).toFixed(4)}`);

	console.log("\n--- Modular Alignment Analysis for k=3 ---");
	console.log("Optimal residue classes modulo 9 and 7:");
	console.log(`  10588881419 mod 9 = ${stijnRecord % 9} (Expected: 3 or 6)`);
	console.log(`  10588881419 mod 7 = ${stijnRecord % 7} (Expected: 3 or 4)`);
	console.log("=========================================================================");
}
