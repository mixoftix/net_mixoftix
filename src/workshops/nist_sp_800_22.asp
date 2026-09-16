<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NIST SP 800-22 (RNG Test Suite)</title>
    <meta name="description" content="Client-side NIST SP 800-22 analysis — paste bits, run tests, export results.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->
	<style>
		body {
			transition: background-color 0.15s, color 0.15s;
		}
	
		/* ========== Light mode (default) ========== */
		body {
			background-color: #f5f5f5;
			color: #222;
		}
	
		.utxoTable {
			font-family: 'Courier New', monospace;
			border-collapse: separate;
			border-spacing: 0;
			border: 1px solid #999;
			border-radius: 10px;
			overflow: hidden;
			margin: 20px auto;
			width: 100%;
			max-width: 1200px;
			background: #fff;
		}
	
		.utxoTable th,
		.utxoTable td {
			padding: 10px;
			text-align: center;
			vertical-align: middle;
			border: 1px solid #ccc;
		}
	
		.utxoTable tr:first-child th:first-child { border-top-left-radius: 10px; }
		.utxoTable tr:first-child th:last-child  { border-top-right-radius: 10px; }
		.utxoTable tr:last-child td:first-child  { border-bottom-left-radius: 10px; }
		.utxoTable tr:last-child td:last-child   { border-bottom-right-radius: 10px; }
	
		.miner-header {
			background-color: #444;
			color: white;
		}
	
		input[type="text"],
		input[type="number"],
		input,
		select,
		textarea {
			font-family: 'Courier New', monospace;
			padding: 4px 6px;
			background: #fff;
			color: #222;
			border: 1px solid #999;
		}
	
		textarea {
			width: 100%;
			min-height: 140px;
			resize: vertical;
			box-sizing: border-box;
		}
	
		.control-btn {
			font-family: 'Courier New', monospace;
			padding: 5px 12px;
			cursor: pointer;
			margin: 0 2px;
			background: #e0e0e0;
			color: #222;
			border: 1px solid #999;
		}
	
		.control-btn.primary {
			background: #2563eb;
			color: white;
			font-weight: bold;
			border-color: #1d4ed8;
		}
	
		.test-chip {
			border: 1px solid #999;
			padding: 4px 8px;
			display: inline-flex;
			align-items: center;
			gap: 6px;
			background: #f8f8f8;
		}
	
		.results-table {
			font-family: 'Courier New', monospace;
			font-size: 0.9em;
			border-collapse: collapse;
			width: 100%;
			max-width: 1200px;
			margin: 10px auto;
		}
	
		.results-table th,
		.results-table td {
			padding: 8px;
			border: 1px solid #ccc;
			text-align: left;
		}
	
		.results-table th {
			background-color: #444;
			color: white;
		}
	
		.progress-bar {
			width: 100%;
			height: 10px;
			border: 1px solid #999;
			background: #e5e5e5;
			margin: 6px 0;
		}
	
		.progress-bar-inner {
			height: 100%;
			width: 0%;
			background: #22c55e;
		}
	
		pre {
			font-family: 'Courier New', monospace;
			background: #f0f0f0;
			border: 1px solid #ccc;
			padding: 8px;
			overflow: auto;
			max-height: 160px;
			color: #222;
			text-align: left;
		}
	
		.pill {
			font-family: 'Courier New', monospace;
			border: 1px solid #999;
			padding: 3px 8px;
			display: inline-block;
			margin: 2px;
			background: #f0f0f0;
		}
	
		label {
			font-family: 'Courier New', monospace;
			margin-right: 6px;
		}
	
		/* ========== Dark mode ========== */
		body.dark-mode {
			background-color: #1a1a1a;
			color: #e0e0e0;
		}
	
		body.dark-mode .utxoTable {
			border-color: #555;
			background: #222;
		}
	
		body.dark-mode .utxoTable th,
		body.dark-mode .utxoTable td {
			border-color: #555;
		}
	
		body.dark-mode .miner-header {
			background-color: #333;
			color: white;
		}
	
		body.dark-mode input[type="text"],
		body.dark-mode input[type="number"],
		body.dark-mode input,
		body.dark-mode select,
		body.dark-mode textarea {
			background: #222;
			color: #eee;
			border-color: #555;
		}
	
		body.dark-mode .control-btn {
			background: #333;
			color: #eee;
			border-color: #555;
		}
	
		body.dark-mode .control-btn.primary {
			background: #2563eb;
			color: white;
			border-color: #3b82f6;
		}
	
		body.dark-mode .test-chip {
			border-color: #555;
			background: #2a2a2a;
		}
	
		body.dark-mode .results-table th,
		body.dark-mode .results-table td {
			border-color: #555;
		}
	
		body.dark-mode .results-table th {
			background-color: #333;
			color: white;
		}
	
		body.dark-mode .progress-bar {
			border-color: #555;
			background: #222;
		}
	
		body.dark-mode pre {
			background: #111;
			border-color: #555;
			color: #eee;
		}
	
		body.dark-mode .pill {
			border-color: #555;
			background: #2a2a2a;
		}
	
		/* Shared helpers */
		.input-container {
			display: flex;
			align-items: center;
			justify-content: center;
			margin-top: 4px;
			flex-wrap: wrap;
			gap: 8px;
		}
	
		.test-list {
			display: flex;
			flex-wrap: wrap;
			gap: 8px;
			justify-content: center;
			font-family: 'Courier New', monospace;
			font-size: 0.9em;
		}

		/* ===== Status colors – force them to stay colorful ===== */
		.status-pass {
			color: #15803d !important;
			font-weight: bold;
			background: rgba(34, 197, 94, 0.15) !important;
		}
		
		.status-fail {
			color: #b91c1c !important;
			font-weight: bold;
			background: rgba(239, 68, 68, 0.15) !important;
		}
		
		.status-skip {
			color: #4b5563 !important;
			background: rgba(107, 114, 128, 0.12) !important;
		}
		
		.status-error {
			color: #b91c1c !important;
			font-weight: bold;
			background: rgba(239, 68, 68, 0.15) !important;
		}
		
		.status-note {
			color: #a16207 !important;
			background: rgba(234, 179, 8, 0.15) !important;
		}
		
		.status-verdict {
			color: #1d4ed8 !important;
			font-weight: bold;
			background: rgba(59, 130, 246, 0.15) !important;
		}
		
		/* Dark mode overrides (keep them vivid) */
		body.dark-mode .status-pass {
			color: #4ade80 !important;
			background: rgba(74, 222, 128, 0.18) !important;
		}
		
		body.dark-mode .status-fail {
			color: #f97373 !important;
			background: rgba(249, 115, 115, 0.18) !important;
		}
		
		body.dark-mode .status-skip {
			color: #9ca3af !important;
			background: rgba(156, 163, 175, 0.12) !important;
		}
		
		body.dark-mode .status-error {
			color: #f97373 !important;
			background: rgba(249, 115, 115, 0.18) !important;
		}
		
		body.dark-mode .status-note {
			color: #fbbf24 !important;
			background: rgba(251, 191, 36, 0.15) !important;
		}
		
		body.dark-mode .status-verdict {
			color: #38bdf8 !important;
			background: rgba(56, 189, 248, 0.18) !important;
		}

	</style>
</head>
<body class="dark-mode">

    <header>
        <h1>NIST SP 800-22 (RNG Test Suite)</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> / Workshops / 
        <a href="/workshops/nist_sp_800_22.asp">NIST SP 800-22 (RNG Test Suite)</a>
    </section>

    <main>
		<section class="content-box">
			<h2>Client-side NIST SP 800-22 Analysis</h2>
			<p>
				This tool lets you test whether a sequence of random bits (0s and 1s) looks truly random,
				using the official statistical tests from the <strong>NIST SP 800-22</strong> standard
				(the same battery used by cryptographers and security researchers).
			</p>
			<p>
				<strong>Everything runs entirely inside your browser</strong> — no data is ever uploaded to a server.
			</p>
		</section>
		
		<section class="content-box">
			<h3>Disclaimer</h3>
			<p>
				This is an educational implementation of the NIST SP 800-22 test suite.
				While the algorithms closely follow the official NIST recommendations, this browser version
				is intended for learning and demonstration purposes only.
			</p>
			<p>
				Results should <strong>not</strong> be used as formal certification or as the sole basis
				for evaluating cryptographic random number generators in production systems.
				For critical applications, always use the official NIST STS software or other validated tools.
			</p>
			<p>
				The author and contributors accept <strong>no liability for any decisions</strong> made based on the output of this tool.
			</p>
		</section>

        <!-- Input Section -->
        <table border="1" class="utxoTable">
            <tr>
                <th colspan="2" class="miner-header">Input Sequence of Bitstreams</th>
            </tr>
            <tr>
                <td colspan="2" style="text-align:left; padding:12px;">
                    <div class="input-container" style="justify-content:flex-start;">
                        <span>Entropy Type:</span>
                        <label><input type="radio" name="entropyType" value="verypoor"> Very Poor</label>
                        <label><input type="radio" name="entropyType" value="poor"> Poor</label>
                        <label><input type="radio" name="entropyType" value="weak" checked> Weak</label>
                        <label><input type="radio" name="entropyType" value="simple"> Simple</label>
                        <label><input type="radio" name="entropyType" value="crypto"> Crypto</label>
                    </div>

                    <div class="input-container" style="justify-content:flex-start; margin-top:10px;">
                        <label for="whiteningSelect">Whitening type:</label>
                        <select id="whiteningSelect">
                            <option value="none">= No Whitening (Raw Entropy)</option>
                            <option value="periodic">! Periodic Pattern</option>
                            <option value="lowentropy">! Low Entropy</option>
                            <option value="weakhash">~ Hash-Counter (Weak)</option>
                            <option value="prnghash">~ Hash-Counter (PRNG)</option>
                            <option value="onebiased">~ Biased One (60%)</option>
                            <option value="hiddenbiased">~ Biased Hidden</option>
                            <option value="xorshift">~ XOR Shift</option>
                            <option value="xorweak">* XOR Weak</option>
                            <option value="fakeaes">~ Fake AES-CTR</option>
                            <option value="fakechacha">* Fake ChaCha</option>
                        </select>
                    </div>
                    <div class="input-container" style="justify-content:flex-start; margin-top:10px;">
                        <label for="genAmount">Bits:</label>
                        <input id="genAmount" type="number" min="1" value="1000" style="width:120px;">
                        <button id="generateBtn" class="control-btn primary">Generate Random Bitstream</button>
                    </div>

                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:left; padding:12px;">
                    <label for="bitsInput">Random bit sequence (Binary 0/1 only)</label><br>
                    <textarea id="bitsInput" placeholder="Paste your RNG output here as a continuous 0/1 string (e.g. 00110101...)"></textarea>
                </td>
            </tr>
            <tr>
                <td style="text-align:left; padding:12px;">
                    <label style="display:inline-flex; align-items:center; gap:6px;">
                        <input type="checkbox" id="truncateCheckbox" checked>
                        Truncate to first 1'000'000 samples
                    </label>
                    <br><br>
                    <label for="fileInput">File:</label>
                    <input id="fileInput" type="file">
                </td>
                <td style="text-align:center; padding:12px;">
                    <span class="pill"><strong id="bitCount">0</strong> bits detected</span><br>
                    <span class="pill">Timeout per test: <strong id="timeoutLabel">5 s</strong></span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding:12px;">
                    <div class="input-container">
                        <button id="analyzeBtn" class="control-btn primary">Evaluate Random Bitstream</button>
                        <button id="clearBtn" class="control-btn">Clear</button>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding:12px;">
                    <div id="progressContainer" style="display:none;">
                        <div class="progress-bar">
                            <div class="progress-bar-inner" id="progressBarInner"></div>
                        </div>
                        <div style="font-family:'Courier New',monospace; font-size:0.85em;">
                            <span id="progressText">Initializing…</span>
                            <span id="currentTestLabel" style="margin-left:12px;"></span>
                        </div>
                    </div>
                </td>
            </tr>
        </table>

        <!-- Results Section -->
		<table class="utxoTable">
			<thead>
				<tr>
					<th>Test</th>
					<th>Status</th>
					<th>p-value</th>
					<th>Notes</th>
				</tr>
			</thead>
			<tbody id="resultsBody">
				<tr>
					<td colspan="4" style="text-align:left; color:#999;">
						No results yet — run the tests to see the report.
					</td>
				</tr>
			</tbody>
		</table>
		<table class="utxoTable" id="meaningTable" style="margin-top:0;">
			<thead>
				<tr>
					<th style="width:90px;">Status</th>
					<th>Explanation</th>
				</tr>
			</thead>
			<tbody id="meaningBody">
				<tr>
					<td colspan="2" style="text-align:left; color:#999;">
						No results yet — run the tests to see the report.
					</td>
				</tr>
			</tbody>
		</table>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok for helping build this NIST RNG Test Suite teaching tool.</p>
        </section>
    </main>

	<script>
		// --- Test definitions (you can add/remove here) -------------------------
		const TESTS = [
			{ id: "frequency", name: "Frequency (Monobit)", short: "T1", minBits: 100 },
			{ id: "blockFrequency", name: "Block Frequency", short: "T2", minBits: 100 },
			{ id: "runs", name: "Runs", short: "T3", minBits: 100 },
			{ id: "longestRun", name: "Longest Run of Ones", short: "T4", minBits: 128 },
			{ id: "rank", name: "Binary Matrix Rank", short: "T5", minBits: 1000 },
			{ id: "fft", name: "Discrete Fourier Transform", short: "T6", minBits: 1000 },
			{ id: "nonOverlapping", name: "Non-overlapping Template", short: "T7", minBits: 1000 },
			{ id: "overlapping", name: "Overlapping Template", short: "T8", minBits: 1000 },
			{ id: "universal", name: "Maurer’s Universal", short: "T9", minBits: 1000 },
			{ id: "linearComplexity", name: "Linear Complexity", short: "T10", minBits: 1000 },
			{ id: "serial", name: "Serial", short: "T11", minBits: 1000 },
			{ id: "approxEntropy", name: "Approximate Entropy", short: "T12", minBits: 1000 },
			{ id: "cumulativeSums", name: "Cumulative Sums", short: "T13", minBits: 100 },
			{ id: "excursions", name: "Random Excursions", short: "T14", minBits: 1000000 },
			{ id: "excursionsVariant", name: "Random Excursions Variant", short: "T15", minBits: 1000000 },
		];

		// --- DOM references -----------------------------------------------------
		const bitsInput = document.getElementById("bitsInput");
		const fileInput = document.getElementById("fileInput");
		const bitCountLabel = document.getElementById("bitCount");
		const analyzeBtn = document.getElementById("analyzeBtn");
		const clearBtn = document.getElementById("clearBtn");
		const progressContainer = document.getElementById("progressContainer");
		const progressBarInner = document.getElementById("progressBarInner");
		const progressText = document.getElementById("progressText");
		const currentTestLabel = document.getElementById("currentTestLabel");
		const resultsBody = document.getElementById("resultsBody");
		const timeoutLabel = document.getElementById("timeoutLabel");

		let timeoutPerTestMs = 30000;          // 30 seconds (was 5 s)
		let results_for_explain = {};

		// --- Helpers --------------------------------------------------------
		function clearAll() {
			resultsBody.innerHTML = ""; // clear
			document.getElementById("meaningBody").innerHTML = '';
		}
		function mix32(x) {
			x ^= x >>> 16;
			x = Math.imul(x, 0x7feb352d);
			x ^= x >>> 15;
			x = Math.imul(x, 0x846ca68b);
			x ^= x >>> 16;
			return x >>> 0;
		}

		// --- BitStreams --------------------------------------------------------
		document.querySelectorAll("input[name='entropyType']").forEach(rb => {
			rb.addEventListener("change", () => {
				const type = document.querySelector("input[name='entropyType']:checked").value;
				badRngContainer.style.display = (type === "bad") ? "block" : "none";
			});
		});
		document.getElementById("generateBtn").addEventListener("click", async () => {
			const amount = parseInt(document.getElementById("genAmount").value, 10);
			const entropyType = document.querySelector("input[name='entropyType']:checked").value;
			const truncate = document.getElementById("truncateCheckbox").checked;

			clearAll();

			// Decide how many bits we will actually generate
			let target = amount;
			if (truncate && target > 1_000_000) {
				target = 1_000_000;
				document.getElementById("genAmount").value = 1000000;
			}

			let bits = [];   // ALWAYS an array

			const whiteningType = document.getElementById("whiteningSelect").value;

			switch (whiteningType) {
				// Bad look, bad RNGs.
				case "none": bits = generateDirectBits(target); break;
				case "periodic": bits = generatePeriodicBits(target); break;
				case "lowentropy": bits = generateLowEntropyBits(target); break;
				// Good look, bad RNGs..
				case "weakhash": bits = generateWeakHashBits(target); break;
				case "prnghash": bits = generateHashCounterBits(target); break;
				case "onebiased": bits = generateBiasedBits(target); break;
				case "hiddenbiased": bits = generateHiddenBiasBits(target); break;
				case "xorshift": bits = generateXORShiftBits(target); break;
				// Good look, good RNGs - but totally fake!
				case "xorweak": bits = generateXORWeakBits(target); break;
				case "fakeaes": bits = generateFakeAESBits(target); break;
				case "fakechacha": bits = generateFakeChaChaBits(target); break;
			}

			/*
			// Simple RNG
			for (let i = 0; i < target; i++) {
				bits.push(Math.random() < 0.5 ? "0" : "1");
			}

			// Crypto RNG (chunked)
			const chunkBytes = 4096;
			let remaining = target;

			while (remaining > 0) {
				const bytesToGen = Math.min(chunkBytes, Math.ceil(remaining / 8));
				const buf = new Uint8Array(bytesToGen);
				crypto.getRandomValues(buf);

				for (let i = 0; i < buf.length && bits.length < target; i++) {
					const byte = buf[i];
					bits.push((byte >> 7) & 1 ? "1" : "0");
					bits.push((byte >> 6) & 1 ? "1" : "0");
					bits.push((byte >> 5) & 1 ? "1" : "0");
					bits.push((byte >> 4) & 1 ? "1" : "0");
					bits.push((byte >> 3) & 1 ? "1" : "0");
					bits.push((byte >> 2) & 1 ? "1" : "0");
					bits.push((byte >> 1) & 1 ? "1" : "0");
					bits.push((byte >> 0) & 1 ? "1" : "0");
				}

				remaining = target - bits.length;
				await new Promise(r => setTimeout(r, 0));   // keep UI responsive
			}
			*/

			// final safety cut
			if (bits.length > target) bits.length = target;

			document.getElementById("bitsInput").value = bits.join("");
			document.getElementById("bitCount").textContent = bits.length;
		});

		// --- Helpers / RNGs ------------------------------------------------------
		const startTime = performance.now();
		let veryPoorCounter = 0;
		let poorCounter = 0;
		let weakCounter = 0;

		function veryPoorRandom() {
			// Real elapsed time
			const currentTimerMs = performance.now() - startTime;

			// counter increase
			veryPoorCounter++;
			veryPoorCounter = veryPoorCounter & 0x3FF;

			// Combine timestamp + counter in a predictable linear way
			let v = (currentTimerMs * veryPoorCounter) >>> 0;
			v = ((v << 7) ^ (v >>> 9)) >>> 0;

			// Guaranteed unsigned 32‑bit
			v = v >>> 0;

			// Guaranteed float in [0,1)
			return v / 0x100000000;
		}
		function poorRandom() {
			// Millisecond timestamp
			const t = Date.now();

			// A tiny counter that cycles every 1024 calls
			poorCounter++;
			poorCounter = poorCounter & 0x3FF;

			// Combine timestamp + counter in a predictable linear way
			let v = (t ^ (poorCounter * 0x9E3779B9)) >>> 0;

			// Extremely weak "mixing"
			v = ((v << 7) ^ (v >>> 9) ^ t) >>> 0;

			// Guaranteed unsigned 32‑bit
			v = v >>> 0;

			// Convert to float in [0, 1)
			return v / 0x100000000;
		}
		function weakRandom() {

			// Real elapsed time
			const currentTimerMs = performance.now() - startTime;
			// counter increase
			weakCounter++;

			let x = mix32(currentTimerMs);
			let y = mix32(weakCounter);

			x = (x + y) >>> 0;
			y = (y ^ x) >>> 0;
			x = (x << 7) | (x >>> 25);

			const nx = mix32(x);
			const ny = mix32(y);
			const nv = (nx ^ ny) >>> 0;                    							// uint32

			// Guaranteed float in [0,1)
			return nv / 0x100000000;
		}
		function simpleRandom() {
			return Math.random();
		}
		function cryptoRandom() {
			return crypto.getRandomValues(new Uint32Array(1))[0] / 0x100000000; // float
		}

		function main_random(asInteger = false) {

			const entropyType = document.querySelector("input[name='entropyType']:checked").value;
			let main_random_val;

			if (entropyType == "verypoor") {
				main_random_val = veryPoorRandom(); // float
			}
			else if (entropyType == "poor") {
				main_random_val = poorRandom();     // float
			}
			else if (entropyType == "weak") {
				main_random_val = weakRandom();     // float
			}
			else if (entropyType == "simple") {
				main_random_val = simpleRandom();   // float
			}
			else if (entropyType == "crypto") 
			{
				main_random_val = cryptoRandom();   // float
			}
			else // Error
			{
				main_random_val = 0.9999;           // float
			}

			// If integer mode is requested → convert float to uint32
			if (asInteger) {
				return (main_random_val * 0xFFFFFFFF) >>> 0;
			}

			return main_random_val; // default float mode
		}

		// --- Helpers / Whitening -------------------------------------------------
		/* 0. direct random */
		function generateDirectBits(amount) {
			let out = [];
			let x;

			for (let i = 0; i < amount; i++) {
				x = (main_random() * 0xffffffff) >>> 0;
				out.push((x & 1) ? "1" : "0");

			}
			return out;
		}
		/* 1. Periodic Pattern — random pattern */
		function generatePeriodicBits(amount) {
			let out = [];
			let pattern = [];

			for (let i = 0; i < 12; i++) {
				// Get a terrible 32‑bit integer from the entropy source
				let v = (main_random() * 0xffffffff) >>> 0;

				// Extract one bit from different positions
				let bit = (v >> i) & 1;

				pattern.push(bit ? "1" : "0");
			}

			while (out.length < amount) out.push(...pattern);
			out.length = amount;
			return out;
		}
		/* 2. Low Entropy — random repeating byte */
		function generateLowEntropyBits(amount) {
			let out = [];
			let byte = (main_random() * 0xff) >>> 0;

			while (out.length < amount) {
				for (let i = 7; i >= 0 && out.length < amount; i--) {
					out.push((byte >> i) & 1 ? "1" : "0");
				}
			}
			return out;
		}
		/* 3. Weak Hash-Counter — stronger failure, fresh output */
		function generateWeakHashBits(amount) {
			let out = [];
			let salt = (main_random() * 0xffffffff) >>> 0;
			let counter = 0;

			while (out.length < amount) {
				let v = ((counter * 0x45D9F3B) ^ (counter >>> 16) ^ salt) >>> 0;

				for (let i = 0; i < 32 && out.length < amount; i++) {
					out.push((v >> (31 - i)) & 1 ? "1" : "0");
				}
				counter++;
			}
			return out;
		}
		/* 4. Hash-Counter (classic) — now with random salt */
		function generateHashCounterBits(amount) {
			let out = [];
			let salt = (main_random() * 0xffffffff) >>> 0;
			let counter = 0;

			while (out.length < amount) {
				let v = ((counter * 2654435761) ^ salt) >>> 0;

				for (let i = 0; i < 32 && out.length < amount; i++) {
					out.push((v >> (31 - i)) & 1 ? "1" : "0");
				}
				counter++;
			}
			return out;
		}
		/* 5. Biased RNG — random bias (60%) */
		function generateBiasedBits(amount) {
			let out = [];

			// Initial bias in [0.50, 0.60]
			let bias = 0.55 + (main_random() * 0.1 - 0.05);

			for (let i = 0; i < amount; i++) {

				// Extract a bit from the poor RNG
				let v = (main_random() * 0xffffffff) >>> 0;
				let bit = (v >> (i & 31)) & 1;

				// Apply bias
				out.push(bit < bias ? "1" : "0");
			}

			return out;
		}
		/* 6. Hidden Bias — drifting bias */
		function generateHiddenBiasBits(amount) {
			let out = [];

			// Initial bias in [0.45, 0.55]
			let bias = 0.50 + (main_random() * 0.1 - 0.05);

			for (let i = 0; i < amount; i++) {

				// Extract a bit from the poor RNG
				let v = (main_random() * 0xffffffff) >>> 0;
				let bit = (v >> (i & 31)) & 1;

				// Apply bias
				out.push(bit < bias ? "1" : "0");

				// Drift bias slightly
				bias += (main_random() * 0.0002 - 0.0001);

				// Clamp bias
				if (bias < 0.45) bias = 0.45;
				if (bias > 0.55) bias = 0.55;
			}

			return out;
		}
		/* 7. XORShift — random seed */
		function generateXORShiftBits(amount) {
			let out = [];
			let x = (main_random() * 0xffffffff) >>> 0;

			for (let i = 0; i < amount; i++) {
				x ^= x << 13;
				x ^= x >>> 17;
				x ^= x << 5;
				out.push((x & 1) ? "1" : "0");
			}
			return out;
		}
		/* 8. XOR Weak Streams — random seeds */
		function generateXORWeakBits(amount) {
			let out = [];
			let a = (main_random() * 0xffffffff) >>> 0;
			let b = (main_random() * 0xffffffff) >>> 0;

			while (out.length < amount) {
				a = (a * 1664525 + 1013904223) >>> 0;
				b ^= b << 5; b ^= b >>> 7; b ^= b << 17;

				let v = a ^ b;

				for (let i = 0; i < 32 && out.length < amount; i++) {
					out.push((v >> (31 - i)) & 1 ? "1" : "0");
				}
			}
			return out;
		}
		/* 9. Fake AES-CTR — random key */
		function generateFakeAESBits(amount) {
			let out = [];
			let key = (main_random() * 0xffffffff) >>> 0;
			let counter = (main_random() * 0xffffffff) >>> 0;

			while (out.length < amount) {
				let v = ((counter * 0x9E3779B9) ^ key) >>> 0;

				for (let i = 0; i < 32 && out.length < amount; i++) {
					out.push((v >> (31 - i)) & 1 ? "1" : "0");
				}
				counter++;
			}
			return out;
		}
		/* 10. Fake ChaCha — random state */
		function generateFakeChaChaBits(amount) {
			let out = [];
			let x = (main_random() * 0xffffffff) >>> 0;
			let y = (main_random() * 0xffffffff) >>> 0;

			while (out.length < amount) {
				x = (x + y) >>> 0;
				y = (y ^ x) >>> 0;
				x = (x << 7) | (x >>> 25);

				for (let i = 0; i < 32 && out.length < amount; i++) {
					out.push((x >> (31 - i)) & 1 ? "1" : "0");
				}
			}
			return out;
		}

		// --- Helpers ------------------------------------------------------------
		function normalizeBits(text) {
			// Keep only 0 and 1
			return (text || "").replace(/[^01]/g, "");
		}
		function updateBitCount() {
			const bits = normalizeBits(bitsInput.value);
			bitCountLabel.textContent = bits.length.toString();
		}
		function setProgress(percent, text, currentTestName) {
			progressBarInner.style.width = `${percent}%`;
			progressText.textContent = text || "";
			currentTestLabel.textContent = currentTestName || "";
		}
		function resetResultsTable() {
			/*
			resultsBody.innerHTML = `
				<tr>
				  <td colspan="4" style="text-align:center; color:#6b7280;">
					No results yet — run the tests to see the report.
				  </td>
				</tr>
			  `;
			*/

			// clear the results
			resultsBody.innerHTML = ``;

		}
		function appendResultRow(test, status, pValue, notes) {
			// Store full results for explainer
			results_for_explain[test.id] = {
				name: test.name,
				pass: status === "PASS",
				status,
				pValue,
				notes
			};

			// --- Build UI row (clean version) ---
			const tr = document.createElement("tr");

			const tdName = document.createElement("td");
			tdName.className = "test-name";
			tdName.textContent = test.name;
			tdName.style.textAlign = "left";

			const tdStatus = document.createElement("td");
			tdStatus.className = "status";
			tdStatus.textContent = status;

			if (status === "PASS") tdStatus.classList.add("status-pass");
			else if (status === "FAIL") tdStatus.classList.add("status-fail");
			else if (status === "SKIP") tdStatus.classList.add("status-skip");
			else tdStatus.classList.add("status-error");

			const tdP = document.createElement("td");
			tdP.textContent = pValue != null ? pValue.toFixed(6) : "—";
			tdP.style.textAlign = "left";

			// --- Notes ---
			const tdNotes = document.createElement("td");
			tdNotes.textContent = notes;
			tdNotes.style.textAlign = "left";

			tr.appendChild(tdName);
			tr.appendChild(tdStatus);
			tr.appendChild(tdP);
			tr.appendChild(tdNotes);

			resultsBody.appendChild(tr);
		}

		// --- Build test chips ---------------------------------------------------
		async function runTests(bits) {
			// Always run every test – ignore the checkboxes
			const enabledTests = TESTS;
		
			resetResultsTable();
			progressContainer.style.display = "block";
			setProgress(0, "Initializing…", "");
		
			const total = enabledTests.length;
			let index = 0;
		
			for (const test of enabledTests) {
				index++;
				const percent = Math.round(((index - 1) / total) * 100);
				setProgress(percent, "Running tests…", test.name);
		
				// Skip if not enough bits
				if (bits.length < test.minBits) {
					appendResultRow(
						test,
						"SKIP",
						null,
						`Requires ≥ ${test.minBits} bits, got ${bits.length}.`
					);
					await new Promise(r => setTimeout(r, 0));
					continue;
				}
		
				try {
					const result = await runTestWithTimeout(test, bits, timeoutPerTestMs);
					const status = result.pass ? "PASS" : "FAIL";
					appendResultRow(
						test,
						status,
						result.pValue,
						result.notes || ""
					);
				} catch (err) {
					appendResultRow(
						test,
						"ERROR",
						null,
						err && err.message ? err.message : "Test failed or timed out."
					);
				}
		
				await new Promise(r => setTimeout(r, 0));
			}
		
			setProgress(100, "Completed.", "");
		
			explainNistResults(results_for_explain);
		
			analyzeBtn.disabled = false;
		}

		function runTestWithTimeout(test, bits, timeoutMs) {
			return new Promise((resolve, reject) => {
				let finished = false;

				const timer = setTimeout(() => {
					if (finished) return;
					finished = true;
					reject(new Error(`Timeout after ${timeoutMs / 1000}s`));
				}, timeoutMs);

				// Here you plug in your actual NIST implementation:
				// For now we use a placeholder that computes a fake p-value.
				(async () => {
					try {
						const result = await runTestImpl(test.id, bits);
						if (finished) return;
						finished = true;
						clearTimeout(timer);
						resolve(result);
					} catch (e) {
						if (finished) return;
						finished = true;
						clearTimeout(timer);
						reject(e);
					}
				})();
			});
		}

		// --- Core: run tests sequentially with timeout & skipping ---------------
		function nist_frequency_test(bits) {
			const n = bits.length;
			let sum = 0;

			for (let i = 0; i < n; i++) {
				sum += bits[i] === "1" ? 1 : -1;
			}

			const sObs = Math.abs(sum) / Math.sqrt(n);
			const pValue = erfc(sObs / Math.sqrt(2));

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `sObs=${sObs.toFixed(6)}`
			};
		}
		function nist_runs_test(bits) {
			const n = bits.length;

			// π = proportion of ones
			let ones = 0;
			for (let i = 0; i < n; i++) {
				if (bits[i] === "1") ones++;
			}
			const pi = ones / n;

			// Precondition: π must not be too far from 0.5
			const tau = 2 / Math.sqrt(n);
			if (Math.abs(pi - 0.5) >= tau) {
				return {
					pass: false,
					pValue: 0,
					notes: `Precondition failed: |π - 0.5| >= 2/sqrt(n). π=${pi.toFixed(6)}`
				};
			}

			// Count runs
			let runs = 1;
			for (let i = 1; i < n; i++) {
				if (bits[i] !== bits[i - 1]) runs++;
			}

			// Expected runs
			const expectedRuns = 2 * n * pi * (1 - pi);

			// Test statistic
			const z = Math.abs(runs - expectedRuns) / (2 * Math.sqrt(2 * n) * pi * (1 - pi));

			const pValue = erfc(z);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `runs=${runs}, expected=${expectedRuns.toFixed(3)}, z=${z.toFixed(6)}`
			};
		}
		function nist_block_frequency_test(bits, M = 128) {
			const n = bits.length;
			const N = Math.floor(n / M);

			if (N === 0) {
				return {
					pass: false,
					pValue: 0,
					notes: `Not enough bits for block size M=${M}. Need at least ${M}.`
				};
			}

			let chi2 = 0;

			for (let i = 0; i < N; i++) {
				let blockOnes = 0;
				for (let j = 0; j < M; j++) {
					if (bits[i * M + j] === "1") blockOnes++;
				}

				const pi = blockOnes / M;
				chi2 += 4 * M * ((pi - 0.5) ** 2);
			}

			const pValue = igamc(N / 2, chi2 / 2);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `chi2=${chi2.toFixed(6)}, blocks=${N}, M=${M}`
			};
		}
		function igamc(a, x) {
			// Based on Numerical Recipes approximation
			const eps = 1e-15;
			let sum = 1 / a;
			let value = sum;
			for (let n = 1; n < 200; n++) {
				sum *= x / (a + n);
				value += sum;
				if (sum < eps * value) break;
			}
			return Math.exp(-x + a * Math.log(x) - logGamma(a)) * value;
		}
		function logGamma(z) {
			const g = 7;
			const p = [
				0.99999999999980993,
				676.5203681218851,
				-1259.1392167224028,
				771.32342877765313,
				-176.61502916214059,
				12.507343278686905,
				-0.13857109526572012,
				9.9843695780195716e-6,
				1.5056327351493116e-7
			];

			if (z < 0.5) {
				return Math.log(Math.PI / (Math.sin(Math.PI * z))) - logGamma(1 - z);
			}

			z -= 1;
			let x = p[0];
			for (let i = 1; i < p.length; i++) {
				x += p[i] / (z + i);
			}

			const t = z + g + 0.5;
			return 0.5 * Math.log(2 * Math.PI) + (z + 0.5) * Math.log(t) - t + Math.log(x);
		}
		function nist_longest_run_test(bits) {
			const n = bits.length;

			// Select block size M and category table based on NIST rules
			let M, K, V, P;

			if (n < 128) {
				return {
					pass: false,
					pValue: 0,
					notes: "Not enough bits for Longest Run test (need ≥ 128)."
				};
			} else if (n < 6272) {
				M = 8;
				K = 3;
				V = [1, 2, 3]; // categories: <=1, =2, >=3
				P = [0.21484375, 0.3671875, 0.41796875];
			} else if (n < 750000) {
				M = 128;
				K = 5;
				V = [4, 5, 6, 7, 8]; // <=4, =5, =6, =7, >=8
				P = [0.1174, 0.2430, 0.2493, 0.1752, 0.2151];
			} else {
				M = 10000;
				K = 6;
				V = [10, 11, 12, 13, 14, 15]; // <=10, =11, =12, =13, =14, >=15
				P = [0.0882, 0.2092, 0.2483, 0.1933, 0.1208, 0.1402];
			}

			const N = Math.floor(n / M);
			if (N === 0) {
				return {
					pass: false,
					pValue: 0,
					notes: `Not enough bits for block size M=${M}.`
				};
			}

			// Count longest runs in each block
			const counts = new Array(K).fill(0);

			for (let i = 0; i < N; i++) {
				const block = bits.slice(i * M, (i + 1) * M);

				let maxRun = 0;
				let currentRun = 0;

				for (let j = 0; j < M; j++) {
					if (block[j] === "1") {
						currentRun++;
						if (currentRun > maxRun) maxRun = currentRun;
					} else {
						currentRun = 0;
					}
				}

				// Categorize maxRun
				if (maxRun <= V[0]) counts[0]++;
				else if (maxRun >= V[K - 1]) counts[K - 1]++;
				else {
					for (let c = 1; c < K - 1; c++) {
						if (maxRun === V[c]) {
							counts[c]++;
							break;
						}
					}
				}
			}

			// Chi-square statistic
			let chi2 = 0;
			for (let i = 0; i < K; i++) {
				const expected = N * P[i];
				chi2 += ((counts[i] - expected) ** 2) / expected;
			}

			const pValue = igamc(K / 2, chi2 / 2);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `chi2=${chi2.toFixed(6)}, blocks=${N}, M=${M}, counts=[${counts.join(", ")}]`
			};
		}
		function nist_rank_test(bits) {
			const n = bits.length;

			const M = 32; // rows
			const Q = 32; // cols
			const blockSize = M * Q;

			const N = Math.floor(n / blockSize);
			if (N === 0) {
				return {
					pass: false,
					pValue: 0,
					notes: `Not enough bits for Rank test. Need ≥ ${blockSize}.`
				};
			}

			let fullRankCount = 0;
			let rank31Count = 0;
			let rankLessCount = 0;

			for (let b = 0; b < N; b++) {
				const block = bits.slice(b * blockSize, (b + 1) * blockSize);

				// Build matrix
				const matrix = [];
				for (let i = 0; i < M; i++) {
					const row = [];
					for (let j = 0; j < Q; j++) {
						row.push(block[i * Q + j] === "1" ? 1 : 0);
					}
					matrix.push(row);
				}

				const r = gf2_rank(matrix);

				if (r === 32) fullRankCount++;
				else if (r === 31) rank31Count++;
				else rankLessCount++;
			}

			// NIST reference probabilities
			const pFull = 0.2888;
			const p31 = 0.5776;
			const pLess = 0.1336;

			const chi2 =
				((fullRankCount - N * pFull) ** 2) / (N * pFull) +
				((rank31Count - N * p31) ** 2) / (N * p31) +
				((rankLessCount - N * pLess) ** 2) / (N * pLess);

			const pValue = Math.exp(-chi2 / 2);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `chi2=${chi2.toFixed(6)}, blocks=${N}, ranks=[${fullRankCount}, ${rank31Count}, ${rankLessCount}]`
			};
		}
		function gf2_rank(mat) {
			const M = mat.length;
			const Q = mat[0].length;

			let rank = 0;
			let row = 0;

			for (let col = 0; col < Q && row < M; col++) {
				// Find pivot
				let pivot = row;
				while (pivot < M && mat[pivot][col] === 0) pivot++;

				if (pivot === M) continue;

				// Swap rows
				if (pivot !== row) {
					const tmp = mat[pivot];
					mat[pivot] = mat[row];
					mat[row] = tmp;
				}

				// Eliminate below
				for (let r = row + 1; r < M; r++) {
					if (mat[r][col] === 1) {
						for (let c = col; c < Q; c++) {
							mat[r][c] ^= mat[row][c];
						}
					}
				}

				row++;
				rank++;
			}

			return rank;
		}
		function nist_fft_test(bits) {
			const n = bits.length;
			if (n < 1000) {
				return { pass: false, pValue: 0, notes: "Need ≥ 1000 bits." };
			}

			// Convert 0/1 → ±1
			const real = new Float64Array(n);
			for (let i = 0; i < n; i++) {
				real[i] = bits[i] === "1" ? 1.0 : -1.0;
			}
			const imag = new Float64Array(n);          // starts at zero

			// In-place mixed-radix FFT
			mixedRadixFFT(real, imag);

			// Magnitudes of first n/2 bins
			const half = n >> 1;
			const T = Math.sqrt(2.995732274 * n);
			let N1 = 0;

			// DC
			if (Math.abs(real[0]) < T) N1++;

			for (let k = 1; k < half; k++) {
				const re = real[k];
				const im = imag[k];
				if (Math.sqrt(re * re + im * im) < T) N1++;
			}

			const N0 = 0.95 * half;
			const d = (N1 - N0) / Math.sqrt(n * 0.95 * 0.05 / 4);
			const pValue = erfc(Math.abs(d) / Math.SQRT2);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `N1=${N1}, N0=${N0.toFixed(1)}, d=${d.toFixed(6)}, T=${T.toFixed(4)}`
			};
		}
		function mixedRadixFFT(re, im) {
			const n = re.length;
			if (n <= 1) return;

			// 1. Factor n
			const factors = factorize(n);

			// 2. Bit-reversal / digit-reversal permutation for the mixed radix
			const perm = mixedRadixPermutation(n, factors);
			const tmpRe = new Float64Array(n);
			const tmpIm = new Float64Array(n);
			for (let i = 0; i < n; i++) {
				tmpRe[i] = re[perm[i]];
				tmpIm[i] = im[perm[i]];
			}
			re.set(tmpRe);
			im.set(tmpIm);

			// 3. Successive radix stages
			let len = 1;
			for (const p of factors) {
				const newLen = len * p;
				const ang = -2 * Math.PI / newLen;
				const wlenRe = Math.cos(ang);
				const wlenIm = Math.sin(ang);

				for (let i = 0; i < n; i += newLen) {
					let wRe = 1.0, wIm = 0.0;
					for (let j = 0; j < len; j++) {
						// butterfly of size p
						for (let k = 0; k < p; k++) {
							const idx = i + j + k * len;
							// For simplicity we use a general p-point DFT here.
							// For the common factors 2 and 5 this is still fast enough.
						}
						// Optimized special cases for the factors that actually appear
						if (p === 2) {
							const uRe = re[i + j];
							const uIm = im[i + j];
							const vRe = re[i + j + len] * wRe - im[i + j + len] * wIm;
							const vIm = re[i + j + len] * wIm + im[i + j + len] * wRe;
							re[i + j] = uRe + vRe;
							im[i + j] = uIm + vIm;
							re[i + j + len] = uRe - vRe;
							im[i + j + len] = uIm - vIm;
						} else {
							// General small-p DFT (p ≤ 7 is fine)
							const bufRe = new Float64Array(p);
							const bufIm = new Float64Array(p);
							for (let k = 0; k < p; k++) {
								bufRe[k] = re[i + j + k * len];
								bufIm[k] = im[i + j + k * len];
							}
							for (let k = 0; k < p; k++) {
								let sumRe = 0, sumIm = 0;
								for (let t = 0; t < p; t++) {
									const angle = 2 * Math.PI * t * k / p;
									const c = Math.cos(angle);
									const s = Math.sin(angle);
									sumRe += bufRe[t] * c - bufIm[t] * s;
									sumIm += bufRe[t] * s + bufIm[t] * c;
								}
								re[i + j + k * len] = sumRe;
								im[i + j + k * len] = sumIm;
							}
						}

						// advance twiddle
						const nextRe = wRe * wlenRe - wIm * wlenIm;
						const nextIm = wRe * wlenIm + wIm * wlenRe;
						wRe = nextRe;
						wIm = nextIm;
					}
				}
				len = newLen;
			}
		}
		function factorize(n) {
			const factors = [];
			while ((n & 1) === 0) { factors.push(2); n >>= 1; }
			for (let p = 3; p * p <= n; p += 2) {
				while (n % p === 0) { factors.push(p); n /= p; }
			}
			if (n > 1) factors.push(n);
			return factors;
		}
		function mixedRadixPermutation(n, factors) {
			const perm = new Int32Array(n);
			for (let i = 0; i < n; i++) {
				let x = i, y = 0;
				for (const p of factors) {
					y = y * p + (x % p);
					x = Math.floor(x / p);
				}
				perm[i] = y;
			}
			return perm;
		}
		function nist_non_overlapping_test(bits) {
			const n = bits.length;

			const m = 9;                 // template length
			const template = "000000000"; // you can change or add more later

			const M = 1032;              // block length (NIST often uses 1032)
			const N = Math.floor(n / M); // number of blocks

			if (N === 0) {
				return {
					pass: false,
					pValue: 0,
					notes: `Not enough bits for Non-overlapping Template test. Need ≥ ${M}.`
				};
			}

			const counts = new Array(N).fill(0);

			// Count non-overlapping occurrences per block
			for (let i = 0; i < N; i++) {
				const block = bits.slice(i * M, (i + 1) * M);
				let pos = 0;
				while (pos <= M - m) {
					let match = true;
					for (let j = 0; j < m; j++) {
						if (block[pos + j] !== template[j]) {
							match = false;
							break;
						}
					}
					if (match) {
						counts[i]++;
						pos += m; // non-overlapping
					} else {
						pos++;
					}
				}
			}

			// Expected mean and variance (Poisson approx)
			const lambda = (M - m + 1) / Math.pow(2, m);
			const sigma2 = lambda * (1 - (2 * m - 1) / Math.pow(2, m));

			// Chi-square over blocks
			let chi2 = 0;
			for (let i = 0; i < N; i++) {
				chi2 += ((counts[i] - lambda) ** 2) / sigma2;
			}

			const pValue = igamc(N / 2, chi2 / 2);

			return {
				pass: pValue >= 0.01,
				pValue,
				//notes: `lambda=${lambda.toFixed(6)}, chi2=${chi2.toFixed(6)}, blocks=${N}, counts=[${counts.join(", ")}]`
				notes: `lambda=${lambda.toFixed(6)}, chi2=${chi2.toFixed(6)}, blocks=${N}`
			};
		}
		function nist_overlapping_test(bits) {
			const n = bits.length;
			const m = 9;
			const M = 1032;
			const K = 5;
			const N = Math.floor(n / M);

			if (N === 0) {
				return { pass: false, pValue: 0, notes: `Need ≥ ${M} bits.` };
			}

			// All-ones template
			const template = "111111111";

			// Count overlapping occurrences in each block
			const nu = new Array(K + 1).fill(0);
			for (let b = 0; b < N; b++) {
				const block = bits.slice(b * M, (b + 1) * M);
				let W = 0;
				for (let pos = 0; pos <= M - m; pos++) {
					if (block.substr(pos, m) === template) W++;
				}
				if (W <= 4) nu[W]++;
				else nu[K]++;
			}

			// Corrected probabilities from the 2014 NIST patch
			// (these replace the broken Poisson / incomplete Pr)
			const pi = [
				0.364091,
				0.185659,
				0.139381,
				0.100571,
				0.070432,
				0.139865
			];

			let chi2 = 0;
			for (let i = 0; i <= K; i++) {
				const expected = N * pi[i];
				chi2 += Math.pow(nu[i] - expected, 2) / expected;
			}

			const pValue = igamc(K / 2, chi2 / 2);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `χ²=${chi2.toFixed(4)}, blocks=${N}, counts=[${nu.join(",")}]`
			};
		}
		function Pr(u, eta) {
			if (u === 0) return Math.exp(-eta);

			let sum = 0;
			for (let l = 1; l <= u; l++) {
				// exp(-η - u·ln2 + l·ln(η) - lgamma(l+1) + lgamma(u) - lgamma(l) - lgamma(u-l+1)? )
				// The reference uses the simplified form below:
				sum += Math.exp(-eta - u * Math.LN2 + l * Math.log(eta)
					- logGamma(l + 1) + logGamma(u)
					- logGamma(l) /* the extra term is absorbed in the reference */);
			}
			// The official loop is actually:
			// sum += exp(-eta - u*log(2) + l*log(eta) - lgam(l+1) + lgam(u) - lgam(u-l+1)? wait
			// Looking at the C:
			// sum += exp(-eta - u*log(2) + l*log(eta) - cephes_lgam(l+1) + cephes_lgam(u) );
			// (they omit the binomial coefficient part in the published source – use the version that matches the binary)
			return sum;   // for practical purposes the values converge to the hard-coded π vector
		}
		function factorial(k) {
			if (k === 0 || k === 1) return 1;
			let r = 1;
			for (let i = 2; i <= k; i++) r *= i;
			return r;
		}
		function nist_universal_test(bits) {
			const n = bits.length;

			// Exact L selection table from universal.c
			let L = 5;
			if (n >= 387840) L = 6;
			if (n >= 904960) L = 7;
			if (n >= 2068480) L = 8;
			if (n >= 4654080) L = 9;
			if (n >= 10342400) L = 10;
			if (n >= 22753280) L = 11;
			if (n >= 49643520) L = 12;
			if (n >= 107560960) L = 13;
			if (n >= 231669760) L = 14;
			if (n >= 496435200) L = 15;
			if (n >= 1059061760) L = 16;

			if (L < 6) {
				return {
					pass: false,
					pValue: 0,
					notes: "Need ≥ 387840 bits for Universal test."
				};
			}

			const Q = 10 * (1 << L);                     // 10 * 2^L
			const nBlocks = Math.floor(n / L);
			const K = nBlocks - Q;
			if (K <= 0) {
				return {
					pass: false,
					pValue: 0,
					notes: `Not enough blocks (L=${L}, Q=${Q}).`
				};
			}

			// Official tables (index = L)
			const expected_value = [
				0, 0, 0, 0, 0, 0,
				5.2177052, 6.1962507, 7.1836656, 8.1764248, 9.1723243,
				10.170032, 11.168765, 12.168070, 13.167693, 14.167488, 15.167379
			];
			const variance = [
				0, 0, 0, 0, 0, 0,
				2.954, 3.125, 3.238, 3.311, 3.356, 3.384,
				3.401, 3.410, 3.416, 3.419, 3.421
			];

			const p = 1 << L;
			const T = new Int32Array(p);                 // last-seen block index

			// helper: L bits → integer
			function blockToInt(offset) {
				let v = 0;
				for (let j = 0; j < L; j++) {
					v = (v << 1) | (bits[offset + j] === "1" ? 1 : 0);
				}
				return v;
			}

			// Initialization
			for (let i = 1; i <= Q; i++) {
				const decRep = blockToInt((i - 1) * L);
				T[decRep] = i;
			}

			// Test phase – accumulate log2 of distances
			let sum = 0;
			for (let i = Q + 1; i <= Q + K; i++) {
				const decRep = blockToInt((i - 1) * L);
				sum += Math.log2(i - T[decRep]);
				T[decRep] = i;
			}

			const phi = sum / K;

			// Variance correction (exact formula from the C source)
			const c = 0.7 - 0.8 / L + (4 + 32 / L) * Math.pow(K, -3 / L) / 15;
			const sigma = c * Math.sqrt(variance[L] / K);

			const arg = Math.abs(phi - expected_value[L]) / (Math.SQRT2 * sigma);
			const pValue = erfc(arg);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `φ=${phi.toFixed(6)}, expected=${expected_value[L].toFixed(6)}, L=${L}, Q=${Q}, K=${K}`
			};
		}
		function universal_Q(L) {
			const table = {
				10: 256,
				11: 256,
				12: 256,
				13: 256,
				14: 256,
				15: 256,
				16: 256,
				17: 256,
				18: 256
			};
			return table[L] || 256;
		}
		function universal_expected(L) {
			const table = {
				10: 6.1962507,
				11: 7.1836656,
				12: 8.1764248,
				13: 9.1723243,
				14: 10.170032,
				15: 11.168765,
				16: 12.168070,
				17: 13.167693,
				18: 14.167488
			};
			return table[L] || 0;
		}
		function universal_variance(L) {
			const table = {
				10: 3.125,
				11: 3.238,
				12: 3.311,
				13: 3.356,
				14: 3.384,
				15: 3.401,
				16: 3.410,
				17: 3.416,
				18: 3.419
			};
			return table[L] || 1;
		}
		function nist_linear_complexity_test(bits) {
			const n = bits.length;

			const M = 500;                     // block size (NIST default)
			const N = Math.floor(n / M);       // number of blocks

			// Require a reasonable number of blocks for chi-square to make sense
			if (N < 100) {
				return {
					pass: false,
					pValue: 0,
					notes: `Not enough blocks for Linear Complexity test. Need ≥ 100 blocks of size ${M}, got ${N}.`
				};
			}

			const mu = (M / 2) + (9 + Math.pow(-1, M + 1)) / 36;

			// Expected probabilities for categories (NIST table)
			const pi = [
				0.010417, 0.03125, 0.125, 0.5, 0.25, 0.0625, 0.020833
			];

			const counts = new Array(7).fill(0);

			for (let blockIndex = 0; blockIndex < N; blockIndex++) {
				const start = blockIndex * M;
				const end = start + M;

				// Convert substring to numeric bit array
				const blockBits = [];
				for (let i = start; i < end; i++) {
					blockBits.push(bits[i] === "1" ? 1 : 0);
				}

				const L = berlekamp_massey(blockBits);

				const T = Math.pow(-1, M) * (L - mu) + (2 / 9);

				let category;
				if (T <= -2.5) category = 0;
				else if (T <= -1.5) category = 1;
				else if (T <= -0.5) category = 2;
				else if (T <= 0.5) category = 3;
				else if (T <= 1.5) category = 4;
				else if (T <= 2.5) category = 5;
				else category = 6;

				counts[category]++;
			}

			// Chi-square
			let chi2 = 0;
			for (let i = 0; i < 7; i++) {
				const expected = N * pi[i];
				chi2 += ((counts[i] - expected) ** 2) / expected;
			}

			const pValue = igamc(7 / 2, chi2 / 2);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `chi2=${chi2.toFixed(6)}, blocks=${N}, counts=[${counts.join(", ")}]`
			};
		}
		function berlekamp_massey(bits) {
			const n = bits.length;
			const c = new Array(n).fill(0);
			const b = new Array(n).fill(0);

			c[0] = 1;
			b[0] = 1;

			let L = 0;
			let m = -1;

			for (let N = 0; N < n; N++) {
				let d = bits[N]; // bits[N] is 0 or 1 (numeric)
				for (let i = 1; i <= L; i++) {
					d ^= (c[i] & bits[N - i]);
				}

				if (d === 1) {
					const temp = c.slice();
					const shift = N - m;

					for (let j = 0; j < n - shift; j++) {
						c[shift + j] ^= b[j];
					}

					if (L <= N / 2) {
						L = N + 1 - L;
						m = N;
						for (let j = 0; j < n; j++) {
							b[j] = temp[j];
						}
					}
				}
			}

			return L;
		}
		function nist_serial_test(bits) {
			const n = bits.length;
			const m = 3; // pattern length

			if (n < 100) {
				return {
					pass: false,
					pValue: 0,
					notes: "Not enough bits for Serial test (need ≥ 100)."
				};
			}

			const psi2_m = serial_psi2(bits, m);
			const psi2_m1 = serial_psi2(bits, m - 1);
			const psi2_m2 = serial_psi2(bits, m - 2);

			const delta1 = psi2_m - psi2_m1;
			const delta2 = psi2_m - 2 * psi2_m1 + psi2_m2;

			const p1 = igamc(Math.pow(2, m - 1) / 2, delta1 / 2);
			const p2 = igamc(Math.pow(2, m - 2) / 2, delta2 / 2);

			return {
				pass: p1 >= 0.01 && p2 >= 0.01,
				pValue: Math.min(p1, p2),
				notes: `psi2(m)=${psi2_m.toFixed(6)}, psi2(m-1)=${psi2_m1.toFixed(6)}, psi2(m-2)=${psi2_m2.toFixed(6)}, p1=${p1.toFixed(6)}, p2=${p2.toFixed(6)}, m=${m}`
			};
		}
		function serial_psi2(bits, m) {
			if (m <= 0) return 0;

			const n = bits.length;
			const patterns = new Array(Math.pow(2, m)).fill(0);

			// Count overlapping m-bit patterns (wrap-around)
			for (let i = 0; i < n; i++) {
				let v = 0;
				for (let j = 0; j < m; j++) {
					const bit = bits[(i + j) % n] === "1" ? 1 : 0;
					v = (v << 1) | bit;
				}
				patterns[v]++;
			}

			let sum = 0;
			for (let i = 0; i < patterns.length; i++) {
				sum += patterns[i] * patterns[i];
			}

			return (sum * Math.pow(2, m) / n) - n;
		}
		function nist_approx_entropy_test(bits) {
			const n = bits.length;
			const m = 2; // NIST default

			if (n < 100) {
				return {
					pass: false,
					pValue: 0,
					notes: "Not enough bits for Approximate Entropy test (need ≥ 100)."
				};
			}

			const phi_m = approx_entropy_phi(bits, m);
			const phi_m1 = approx_entropy_phi(bits, m + 1);

			const apEn = phi_m - phi_m1;

			const chi2 = 2 * n * (Math.log(2) - apEn);
			const pValue = igamc(Math.pow(2, m - 1), chi2 / 2);

			return {
				pass: pValue >= 0.01,
				pValue,
				notes: `ApEn=${apEn.toFixed(6)}, chi2=${chi2.toFixed(6)}, m=${m}`
			};
		}
		function approx_entropy_phi(bits, m) {
			const n = bits.length;
			const patterns = new Array(Math.pow(2, m)).fill(0);

			// Count overlapping m-bit patterns (wrap-around)
			for (let i = 0; i < n; i++) {
				let v = 0;
				for (let j = 0; j < m; j++) {
					const bit = bits[(i + j) % n] === "1" ? 1 : 0;
					v = (v << 1) | bit;
				}
				patterns[v]++;
			}

			let sum = 0;
			for (let i = 0; i < patterns.length; i++) {
				const p = patterns[i] / n;
				if (p > 0) sum += p * Math.log(p);
			}

			return sum;
		}
		function nist_cumulative_sums_test(bits) {
			const n = bits.length;

			if (n < 10) {
				return {
					pass: false,
					pValue: 0,
					notes: "Not enough bits for Cumulative Sums test (need ≥ 10)."
				};
			}

			const pForward = cumulative_sums_direction(bits, false);
			const pReverse = cumulative_sums_direction(bits, true);

			return {
				pass: pForward >= 0.01 && pReverse >= 0.01,
				pValue: Math.min(pForward, pReverse),
				notes: `pForward=${pForward.toFixed(6)}, pReverse=${pReverse.toFixed(6)}`
			};
		}
		function cumulative_sums_direction(bits, reverse) {
			const n = bits.length;

			// Convert bits to ±1
			const X = new Array(n);
			for (let i = 0; i < n; i++) {
				const b = reverse ? bits[n - 1 - i] : bits[i];
				X[i] = b === "1" ? 1 : -1;
			}

			// Compute cumulative sums
			let S = 0;
			let maxAbs = 0;
			for (let i = 0; i < n; i++) {
				S += X[i];
				const a = Math.abs(S);
				if (a > maxAbs) maxAbs = a;
			}

			const z = maxAbs;
			const sqrtN = Math.sqrt(n);

			// NIST formula
			let p = 0;

			// First summation
			for (let k = Math.floor((-n / z + 1) / 4); k <= Math.floor((n / z - 1) / 4); k++) {
				const x = (4 * k + 1) * z / sqrtN;
				p += normalCDF(x) - normalCDF((4 * k - 1) * z / sqrtN);
			}

			// Second summation
			for (let k = Math.floor((-n / z - 3) / 4); k <= Math.floor((n / z - 1) / 4); k++) {
				const x = (4 * k + 3) * z / sqrtN;
				p -= normalCDF(x) - normalCDF((4 * k + 1) * z / sqrtN);
			}

			return 1 - p;
		}
		function normalCDF(x) {
			return 0.5 * (1 + erf(x / Math.sqrt(2)));
		}
		function erf(x) {
			// Abramowitz-Stegun approximation
			const a1 = 0.254829592;
			const a2 = -0.284496736;
			const a3 = 1.421413741;
			const a4 = -1.453152027;
			const a5 = 1.061405429;
			const p = 0.3275911;

			const sign = x < 0 ? -1 : 1;
			x = Math.abs(x);

			const t = 1 / (1 + p * x);
			const y = 1 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * Math.exp(-x * x);

			return sign * y;
		}
		function erfc(x) {
			return 1 - erf(x);
		}
		function nist_random_excursions_test(bits) {
			const n = bits.length;

			if (n < 1000000) {
				return {
					pass: false,
					pValue: null,
					notes: `Requires ≥ 1000000 bits, got ${n}.`
				};
			}

			// Convert bits to +1 / -1
			const X = new Array(n);
			for (let i = 0; i < n; i++) {
				X[i] = bits[i] === "1" ? 1 : -1;
			}

			// Build cumulative sum
			const S = [0];
			for (let i = 0; i < n; i++) {
				S.push(S[i] + X[i]);
			}

			// Identify zero crossings (cycles)
			const zeroPositions = [];
			for (let i = 1; i < S.length; i++) {
				if (S[i] === 0) zeroPositions.push(i);
			}

			const cycles = zeroPositions.length;
			if (cycles < 1) {
				return {
					pass: false,
					pValue: null,
					notes: "No cycles found (random walk never returned to zero)."
				};
			}

			// States to check
			const states = [-4, -3, -2, -1, 1, 2, 3, 4];

			const counts = {};
			states.forEach(s => counts[s] = 0);

			// Count visits to each state within each cycle
			let start = 0;
			for (let c = 0; c < cycles; c++) {
				const end = zeroPositions[c];
				for (let i = start; i < end; i++) {
					const val = S[i];
					if (counts[val] !== undefined) counts[val]++;
				}
				start = end;
			}

			// Expected probabilities (NIST table)
			const P = {
				"-4": 0.000671,
				"-3": 0.005132,
				"-2": 0.026521,
				"-1": 0.121117,
				"1": 0.121117,
				"2": 0.026521,
				"3": 0.005132,
				"4": 0.000671
			};

			// Compute p-values per state
			const pValues = {};
			for (const s of states) {
				const x = counts[s];
				const expected = cycles * P[s];
				const chi2 = ((x - expected) ** 2) / expected;
				pValues[s] = Math.exp(-chi2 / 2);
			}

			return {
				pass: Object.values(pValues).every(p => p >= 0.01),
				pValue: Math.min(...Object.values(pValues)),
				//notes: `cycles=${cycles}, counts=${JSON.stringify(counts)}, pValues=${JSON.stringify(pValues)}`
				notes:
					`cycles=${cycles}\n` +
					`min pValue=${Math.min(...Object.values(pValues)).toExponential(3)}\n` +
					`max pValue=${Math.max(...Object.values(pValues)).toExponential(3)}`
			};
		}
		function nist_random_excursions_variant_test(bits) {
			const n = bits.length;

			if (n < 1000000) {
				return {
					pass: false,
					pValue: null,
					notes: `Requires ≥ 1000000 bits, got ${n}.`
				};
			}

			// Convert bits to +1 / -1
			const X = new Array(n);
			for (let i = 0; i < n; i++) {
				X[i] = bits[i] === "1" ? 1 : -1;
			}

			// Build cumulative sum
			const S = [0];
			for (let i = 0; i < n; i++) {
				S.push(S[i] + X[i]);
			}

			// Identify zero crossings (cycles)
			const zeroPositions = [];
			for (let i = 1; i < S.length; i++) {
				if (S[i] === 0) zeroPositions.push(i);
			}

			const cycles = zeroPositions.length;
			if (cycles < 1) {
				return {
					pass: false,
					pValue: null,
					notes: "No cycles found (random walk never returned to zero)."
				};
			}

			// States to check
			const states = [-9, -8, -7, -6, -5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6, 7, 8, 9];

			const counts = {};
			states.forEach(s => counts[s] = 0);

			// Count visits to each state
			let start = 0;
			for (let c = 0; c < cycles; c++) {
				const end = zeroPositions[c];
				for (let i = start; i < end; i++) {
					const val = S[i];
					if (counts[val] !== undefined) counts[val]++;
				}
				start = end;
			}

			// Expected probability for each state (NIST formula)
			const pValues = {};
			for (const s of states) {
				const x = counts[s];
				const p = Math.exp(-Math.abs(s)) * (1 - Math.exp(-Math.abs(s)));
				const expected = cycles * p;

				const chi2 = ((x - expected) ** 2) / expected;
				pValues[s] = Math.exp(-chi2 / 2);
			}

			return {
				pass: Object.values(pValues).every(p => p >= 0.01),
				pValue: Math.min(...Object.values(pValues)),
				//notes: `cycles=${cycles}, counts=${JSON.stringify(counts)}, pValues=${JSON.stringify(pValues)}`
				notes:
					`cycles=${cycles}\n` +
					`min pValue=${Math.min(...Object.values(pValues)).toExponential(3)}\n` +
					`max pValue=${Math.max(...Object.values(pValues)).toExponential(3)}`
			};
		}

		async function runTestImpl(testId, bits) {
			switch (testId) {

				case "frequency":
					return nist_frequency_test(bits);

				case "blockFrequency":
					return nist_block_frequency_test(bits);

				case "runs":
					return nist_runs_test(bits);

				case "longestRun":
					return nist_longest_run_test(bits);

				case "rank":
					return nist_rank_test(bits);

				case "fft":
					return nist_fft_test(bits);

				case "nonOverlapping":
					return nist_non_overlapping_test(bits);

				case "overlapping":
					return nist_overlapping_test(bits);

				case "universal":
					return nist_universal_test(bits);

				case "linearComplexity":
					return nist_linear_complexity_test(bits);

				case "serial":
					return nist_serial_test(bits);

				case "approxEntropy":
					return nist_approx_entropy_test(bits);

				case "cumulativeSums":
					return nist_cumulative_sums_test(bits);

				case "excursions":
					return nist_random_excursions_test(bits);

				case "excursionsVariant":
					return nist_random_excursions_variant_test(bits);

				default:
					throw new Error(`Unknown test: ${testId}`);
			}
		}

		function explainNistResults(results) {
			const body = document.getElementById("meaningBody");
			body.innerHTML = "";
		
			function addRow(status, text) {
				const tr = document.createElement("tr");
		
				const tdStatus = document.createElement("td");
				tdStatus.textContent = status;
				tdStatus.className = "status-" + status.toLowerCase();
				tdStatus.style.textAlign = "center";
		
				const tdText = document.createElement("td");
				tdText.textContent = text;
				tdText.style.textAlign = "left";
		
				tr.appendChild(tdStatus);
				tr.appendChild(tdText);
				body.appendChild(tr);
			}
		
			const fail = id => results[id] && results[id].status === "FAIL";
			const skip = id => results[id] && results[id].status === "SKIP";
		
			// --- Frequency ---
			if (fail("frequency"))
				addRow("FAIL", "Frequency: Bias detected — imbalance between 0s and 1s.");
			else
				addRow("PASS", "Frequency: Balanced distribution of 0s and 1s.");
		
			// --- Block Frequency ---
			if (fail("blockFrequency"))
				addRow("FAIL", "Block Frequency: Local bias inside blocks — uneven distribution.");
			else
				addRow("PASS", "Block Frequency: No local bias detected.");
		
			// --- Runs ---
			if (fail("runs"))
				addRow("FAIL", "Runs: Abnormal number of runs — possible clumping or structure.");
			else
				addRow("PASS", "Runs: Alternation between bits appears natural.");
		
			// --- Longest Run ---
			if (fail("longestRun"))
				addRow("FAIL", "Longest Run: Streak lengths deviate from expected randomness.");
			else
				addRow("PASS", "Longest Run: Streak lengths are within expected limits.");
		
			// --- Rank ---
			if (fail("rank"))
				addRow("FAIL", "Binary Matrix Rank: Linear dependencies detected — low entropy.");
			else
				addRow("PASS", "Binary Matrix Rank: No detectable linear structure.");
		
			// --- FFT ---
			if (fail("fft"))
				addRow("FAIL", "Discrete Fourier Transform: Strong periodic patterns detected.");
			else
				addRow("PASS", "Discrete Fourier Transform: No periodic structure detected.");
		
			// --- Template Tests ---
			const templateFail = fail("nonOverlapping") || fail("overlapping");
			if (templateFail)
				addRow("FAIL", "Template Tests: Repeated short patterns detected.");
			else
				addRow("PASS", "Template Tests: No repeated short patterns.");
		
			// --- Maurer Universal ---
			if (skip("universal"))
				addRow("SKIP", "Maurer Universal: Sequence too short — skipped.");
			else if (fail("universal"))
				addRow("FAIL", "Maurer Universal: Sequence is highly compressible — strong global structure.");
			else
				addRow("PASS", "Maurer Universal: Compressibility matches randomness.");
		
			// --- Linear Complexity ---
			if (skip("linearComplexity"))
				addRow("SKIP", "Linear Complexity: Sequence too short — skipped.");
			else if (fail("linearComplexity"))
				addRow("FAIL", "Linear Complexity: Sequence resembles output of a simple linear generator.");
			else
				addRow("PASS", "Linear Complexity: Complexity matches a random generator.");
		
			// --- Serial ---
			if (fail("serial"))
				addRow("FAIL", "Serial: m-bit patterns repeat abnormally.");
			else
				addRow("PASS", "Serial: No abnormal repetition of m-bit patterns.");
		
			// --- Approx Entropy ---
			if (fail("approxEntropy"))
				addRow("FAIL", "Approximate Entropy: Pattern complexity deviates from randomness.");
			else
				addRow("PASS", "Approximate Entropy: Pattern complexity appears random.");
		
			// --- Cumulative Sums ---
			if (fail("cumulativeSums"))
				addRow("FAIL", "Cumulative Sums: Long-term drift detected — imbalance over time.");
			else
				addRow("PASS", "Cumulative Sums: No long-term drift — sequence stays balanced.");
		
			// --- Excursions ---
			if (skip("excursions"))
				addRow("SKIP", "Random Excursions: Sequence too short — skipped.");
			else if (fail("excursions"))
				addRow("FAIL", "Random Excursions: State visit deviations — walk behavior not random.");
			else
				addRow("PASS", "Random Excursions: Walk behavior matches randomness.");
		
			if (skip("excursionsVariant"))
				addRow("SKIP", "Random Excursions Variant: Sequence too short — skipped.");
			else if (fail("excursionsVariant"))
				addRow("FAIL", "Random Excursions Variant: State visit frequencies abnormal.");
			else
				addRow("PASS", "Random Excursions Variant: State visits appear random.");
		
			// --- Combined interpretations ---
			if (fail("fft") && fail("universal"))
				addRow("NOTE", "Combined: FFT and Maurer both failed — strong periodic structure and extreme compressibility.");
		
			if (fail("rank") && fail("linearComplexity"))
				addRow("NOTE", "Combined: Rank and Linear Complexity failed — sequence resembles a simple linear generator.");
		
			if (fail("frequency") && fail("runs"))
				addRow("NOTE", "Combined: Frequency and Runs failed — biased and patterned sequence.");
		
			if (templateFail && fail("serial"))
				addRow("NOTE", "Combined: Template and Serial failed — repeated short patterns detected.");
		
			// --- Final Verdict ---
			const failCount = Object.values(results).filter(r => r.status === "FAIL").length;
		
			if (failCount === 0)
				addRow("VERDICT", "All applicable tests passed — sequence is consistent with randomness.");
			else if (failCount <= 2)
				addRow("VERDICT", "Minor issues detected — sequence is probably random.");
			else if (failCount <= 5)
				addRow("VERDICT", "Multiple failures — sequence is likely not random.");
			else
				addRow("VERDICT", "Severe failures — sequence is not random.");
		}

		// --- Event wiring -------------------------------------------------------
		bitsInput.addEventListener("input", () => {
			bitsInput.value = normalizeBits(bitsInput.value);

			clearAll();

			const truncate = document.getElementById("truncateCheckbox").checked;
			if (truncate && bitsInput.value.length > 1_000_000) {
				bitsInput.value = bitsInput.value.slice(0, 1_000_000);
			}
			updateBitCount();
		});
		fileInput.addEventListener("change", async (e) => {
			const file = e.target.files && e.target.files[0];
			if (!file) return;

			clearAll();

			const name = file.name.toLowerCase();
			let bits = "";

			if (name.endsWith(".txt")) {
				const text = await file.text();
				bits = normalizeBits(text);
			} else {
				// binary mode
				const buffer = await file.arrayBuffer();
				const bytes = new Uint8Array(buffer);
				const bitArray = [];
				for (let b of bytes) {
					bitArray.push((b >> 7) & 1);
					bitArray.push((b >> 6) & 1);
					bitArray.push((b >> 5) & 1);
					bitArray.push((b >> 4) & 1);
					bitArray.push((b >> 3) & 1);
					bitArray.push((b >> 2) & 1);
					bitArray.push((b >> 1) & 1);
					bitArray.push((b >> 0) & 1);
				}
				bits = bitArray.join("");
			}

			// ---- truncation logic ----
			const truncate = document.getElementById("truncateCheckbox").checked;
			if (truncate && bits.length > 1_000_000) {
				bits = bits.slice(0, 1_000_000);
			}

			bitsInput.value = bits;
			updateBitCount();
		});
		analyzeBtn.addEventListener("click", () => {
			const bits = normalizeBits(bitsInput.value);
			if (!bits.length) {
				alert("Please paste a binary sequence (0/1) or load a file first.");
				return;
			}

			analyzeBtn.disabled = true;
			progressContainer.style.display = "block";
			setProgress(0, "Preparing…", "");
			clearAll();

			// Slight delay to let UI update
			setTimeout(() => {
				runTests(bits);
			}, 80);
		});
		clearBtn.addEventListener("click", () => {
			bitsInput.value = "";
			fileInput.value = "";
			updateBitCount();
			resetResultsTable();
			progressContainer.style.display = "none";
			setProgress(0, "", "");
			analyzeBtn.disabled = false;
			clearAll();
		});

		function init() {
			updateBitCount();
			timeoutLabel.textContent = `${timeoutPerTestMs / 1000} s`;
			resetResultsTable();
		}
		init();
	</script>


    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>