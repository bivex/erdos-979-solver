/**
 * Hardy-Littlewood Circle Method & Singular Series Engine for k=4
 * Erdős Problem #979: n = p_1^4 + p_2^4 + p_3^4 + p_4^4
 */

function gcd(a: number, b: number): number {
	while (b !== 0) {
		const t = b;
		b = a % b;
		a = t;
	}
	return a;
}

// Euler totient function phi(q)
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

// Exponential sum S(a, q) = sum_{1 <= h <= q, gcd(h,q)=1} e(a * h^4 / q)
function computeExponentialSum(a: number, q: number): { real: number; imag: number } {
	let re = 0;
	let im = 0;
	for (let h = 1; h <= q; h++) {
		if (gcd(h, q) === 1) {
			const power4 = (h * h * h * h) % q;
			const angle = (2 * Math.PI * a * power4) / q;
			re += Math.cos(angle);
			im += Math.sin(angle);
		}
	}
	return { real: re, imag: im };
}

// A_q(n) term in Singular Series S_4(n)
function computeAq(q: number, n: number): number {
	const phiQ = phi(q);
	const factor = 1 / (phiQ ** 4);
	let sum = 0;

	for (let a = 1; a < q; a++) {
		if (gcd(a, q) === 1) {
			const S = computeExponentialSum(a, q);
			// S^4 in complex arithmetic
			// (re + i*im)^2 = re^2 - im^2 + 2i*re*im
			const sqRe = S.real * S.real - S.imag * S.imag;
			const sqIm = 2 * S.real * S.imag;
			const S4Re = sqRe * sqRe - sqIm * sqIm;
			const S4Im = 2 * sqRe * sqIm;

			// e(-a * n / q) = cos(-2pi*a*n/q) + i*sin(-2pi*a*n/q)
			const angle = (-2 * Math.PI * a * n) / q;
			const eRe = Math.cos(angle);
			const eIm = Math.sin(angle);

			// Real part of S^4 * e(-an/q)
			const term = S4Re * eRe - S4Im * eIm;
			sum += term;
		}
	}
	return factor * sum;
}

/**
 * Computes truncated Singular Series S_4(n) up to modulus Q
 */
export function computeSingularSeries(n: number, maxQ: number = 30): number {
	let S4 = 1.0;
	for (let q = 2; q <= maxQ; q++) {
		S4 += computeAq(q, n);
	}
	return S4;
}

// Execution runner
if (import.meta.main) {
	console.log("=========================================================================");
	console.log("  HARDY-LITTLEWOOD CIRCLE METHOD: SINGULAR SERIES S_4(n) ANALYZER");
	console.log("=========================================================================\n");

	const landmarkNumbers = [
		{ name: "Landmark 1", n: 199898912404 },
		{ name: "Landmark 2", n: 228696341524 },
		{ name: "Landmark 3", n: 318417970324 },
		{ name: "Landmark 4", n: 955118369284 },
		{ name: "Landmark 5", n: 1215633611284 },
		{ name: "Landmark 6", n: 7431769413844 },
	];

	console.log("Evaluating Singular Series S_4(n) for 6 landmark numbers with f_4(n) = 4:\n");
	for (const item of landmarkNumbers) {
		const s4 = computeSingularSeries(item.n, 30);
		console.log(`  ${item.name} (n = ${item.n}):  S_4(n) ≈ ${s4.toFixed(4)}`);
	}

	console.log("\nComparison with non-record numbers (n = 100000000000):");
	const s4_random = computeSingularSeries(100000000000, 30);
	console.log(`  Random n = 100,000,000,000:       S_4(n) ≈ ${s4_random.toFixed(4)}`);
	console.log("=========================================================================");
}
