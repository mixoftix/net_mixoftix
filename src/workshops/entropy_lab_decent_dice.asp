<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Decent Dice (Entropy Lab)</title>
    <meta name="description" content="Entropy by 2D physics-based dice drop simulator with material properties, adhesion, temperature, humidity, altitude, timer-based noisy random, dice/hex mode and exact session import/export.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

    <style>
        body { transition: background-color 0.15s, color 0.15s; }
        .controls {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
            gap: 12px;
            margin-bottom: 18px;
        }
        label { display: block; font-size: 13px; margin-bottom: 4px; font-weight: 600; }
        input, select, button {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            line-height: 1.3;
            height: 38px;
            box-sizing: border-box;
        }
        input[type="checkbox"] {
            width: auto; height: auto; padding: 0; border: none; border-radius: 0;
        }
        button {
            background: #2563eb; color: white; border: none; cursor: pointer; font-weight: 600;
        }
        button:hover { background: #1d4ed8; }
        button:disabled { background: #94a3b8; cursor: not-allowed; }
        button.secondary { background: #0f766e; }
        button.secondary:hover { background: #0d9488; }
        button.shuffle { background: #7c3aed; }
        button.shuffle:hover { background: #6d28d9; }
        button.import { background: #059669; }
        button.import:hover { background: #047857; }
        button.export { background: #d97706; }
        button.export:hover { background: #b45309; }

        #canvas-container { text-align: center; margin: 16px 0; }
        canvas { background: #eef2ff; border-radius: 8px; max-width: 100%; }
        body.dark-mode canvas { background: #1e293b; }

        #log {
            font-family: ui-monospace, 'Courier New', monospace;
            font-size: 13px;
            padding: 16px;
            border-radius: 8px;
            white-space: pre-wrap;
            max-height: 480px;
            overflow-y: auto;
            background: #1e293b;
            color: #e2e8f0;
        }
        body:not(.dark-mode) #log {
            background: #f1f5f9; color: #1e293b; border: 1px solid #cbd5e1;
        }
        .timer-line {
            display: flex;
            align-items: center;
            gap: 18px;
            margin-bottom: 14px;
            flex-wrap: wrap;
        }
        .seed-row {
            display: grid;
            grid-template-columns: 1fr 1fr auto auto;
            gap: 10px;
            margin-bottom: 16px;
            align-items: end;
        }
        @media (max-width: 700px) {
            .seed-row { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body class="dark-mode">
    <header>
        <h1>Decent Dice (Entropy Lab)</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
        Workshops /
        <a href="/workshops/entropy_lab_decent_dice.asp">Decent Dice (Entropy Lab)</a>
    </section>

    <main>
        <section class="content-box">
            <h2>2D Rigid-body Dice with Material Physics</h2>
            <p>
                Physically-based 2D square die with restitution, friction, adhesion, temperature, humidity and altitude.
                Timer-based noisy random, Dice/Hex label modes, and full exact-session import/export are supported.
            </p>
			<p>
				<strong>Everything runs entirely inside your browser</strong> — no data is ever uploaded to a server.
			</p>
        </section>
        <section class="content-box">
            <h2>Disclaimer</h2>
            <p>
				This tool is designed as a rich, physically-influenced entropy source.
				It combines timing, material parameters, and strong internal randomness to generate unpredictable values. 
				For critical cryptographic purposes (such as generating private keys), the outputs of this simulator should be treated only as raw entropy.
				Users should move these outputs into stronger, well-reviewed systems and apply proper key derivation methods.
				Use for high-stakes cryptography is entirely at the user’s own risk.
            </p>
        </section>
		<section class="content-box">
			<h2>License</h2>
			<p>
				The <strong>Decent Dice</strong> project is source-available and provided for academic review and public pull-request contributions under 
				a restricted, audit-only license. Such contributions may be reviewed and merged solely at the author's discretion. 
				Please read the official <a href="https://github.com/mixoftix/net_mixoftix/blob/main/LICENSE" target="_blank" rel="noopener noreferrer">license declaration on GitHub</a>.
			</p>
		</section>

		<section class="content-box">
			<h2>Simulator</h2>
		
			<div class="controls">
				<!-- New / converted controls -->
				<div>
					<label>Show animation</label>
					<select id="showAnim">
						<option value="true" selected>true</option>
						<option value="false">false</option>
					</select>
				</div>
				<div>
					<label>Timer (ms)</label>
					<input type="text" id="timerDisplay" value="0" readonly>
				</div>
				<div>
					<label>&nbsp;</label>
					<button class="import" id="importBtn">Import</button>
				</div>
				<div>
					<label>&nbsp;</label>
					<button class="export" id="exportBtn">Export</button>
				</div>

				<!-- Streaming Mode -->
				<div>
					<label>Generate stream</label>
					<select id="generateStream">
						<option value="false" selected>false</option>
						<option value="true">true</option>
					</select>
				</div>
				<div>
					<label>Sequence amount</label>
					<input type="number" id="sequenceAmount" value="16" min="1" max="10000" step="1">
				</div>
				<div>
					<label>Sequence batch size</label>
					<input type="number" id="batchSize" value="10" min="5" max="500" step="5">
				</div>
				<div>
					<label>Update every (batches)</label>
					<input type="number" id="updateEvery" value="5" min="1" max="50" step="1">
				</div>
		
				<!-- Original controls -->
				<div>
					<label>Random mode</label>
					<select id="randMode">
						<option value="cryptography">cryptography</option>
						<option value="simple">simple</option>
						<option value="weak" selected>weak</option>
						<option value="poor">poor</option>
						<option value="verypoor">very poor</option>
					</select>
				</div>
				<div>
					<label>Noise mode</label>
					<select id="noiseMode">
						<option value="trigonometry" selected>trigonometry</option>
						<option value="xorxormix" >xor-xor-mix</option>
						<option value="mixmixxor" >mix-mix-xor</option>
						<option value="trimixxor" >tri-mix-xor</option>
						<option value="xcstrixor" >xcs-tri-xor</option>
					</select>
				</div>
				<div>
					<label>Seed / Timer factor</label>
					<input type="text" id="seedBox" value="0.000000" readonly title="Live until you press Drop, then freezes">
				</div>
				<div>
					<label>Simulation time (s)</label>
					<input type="number" id="simTime" value="12" step="0.5" min="5" max="25">
				</div>

				<div>
					<label>Dice material</label>
					<select id="diceMat">
						<option value="plastic" selected>plastic</option>
						<option value="wood">wood</option>
						<option value="metal">metal</option>
						<option value="rubber">rubber</option>
					</select>
				</div>
				<div>
					<label>Surface material</label>
					<select id="surfMat">
						<option value="wood" selected>wood</option>
						<option value="carpet">carpet</option>
						<option value="glass">glass</option>
						<option value="metal">metal</option>
						<option value="rubber">rubber</option>
						<option value="felt">felt</option>
					</select>
				</div>
				<div>
					<label>Temperature (°C)</label>
					<input type="number" id="temperature" value="22" step="1" min="-10" max="50">
				</div>
				<div>
					<label>Humidity (%)</label>
					<input type="number" id="humidity" value="45" step="1" min="0" max="100">
				</div>
				<div>
					<label>Altitude (km)</label>
					<input type="number" id="altitude" value="0" step="10" min="0" max="36000">
				</div>
				<div>
					<label>Drop height (m)</label>
					<input type="number" id="height" value="2.1" step="0.1" min="0.3" max="5">
				</div>
				<div>
					<label>Initial spin (rad/s)</label>
					<input type="number" id="initOmega" value="3.0" step="0.5" min="-30" max="30">
				</div>
				<div>
					<label>Initial top face (0-3)</label>
					<input type="number" id="initTop" value="0" min="0" max="3" step="1">
				</div>

				<div>
					<label>Label mode</label>
					<select id="labelMode">
						<option value="dice" selected>Dice (1-6)</option>
						<option value="hex">Hex (0-f)</option>
						<option value="bin">Bin (0,1)</option>
					</select>
				</div>
				<div>
					<label>&nbsp;</label>
					<button id="shuffleBtn" class="shuffle">Shuffle settings</button>
				</div>
				<div>
					<label>&nbsp;</label>
					<button id="dropBtn">Drop the dice</button>
				</div>
				<div>
					<label>&nbsp;</label>
					<button id="replayBtn" class="secondary" disabled>Replay animation</button>
				</div>
			</div>
		
			<div id="canvas-container">
				<canvas id="c" width="640" height="520"></canvas>
			</div>
		
			<div id="log-container">
			  <textarea id="log" style="height:280px;">
Click “Shuffle settings” or “Drop the dice” to start
			  </textarea>
			</div>
			
		</section>

        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok for its invaluable assistance in creating this Physically-based dice drop simulator for the <strong>Deep Inside</strong> workshop series.</p>
        </section>
    </main>

    <script>
        // ---------- Dark mode ----------
        function toggleDarkMode() {
            const body = document.body;
            const checkbox = document.getElementById('darkModeToggle');
            if (checkbox.checked) {
                body.classList.add('dark-mode');
                body.classList.remove('light-mode');
            } else {
                body.classList.remove('dark-mode');
                body.classList.add('light-mode');
            }
        }

        // ---------- Materials ----------
        const DICE_MATERIALS = {
            plastic: [0.55, 0.35, 0.02],
            wood:    [0.45, 0.45, 0.08],
            metal:   [0.70, 0.25, 0.01],
            rubber:  [0.40, 0.60, 0.18],
        };
        const SURFACE_MATERIALS = {
            wood:   [0.50, 0.40, 0.10],
            carpet: [0.30, 0.70, 0.25],
            glass:  [0.65, 0.20, 0.03],
            metal:  [0.70, 0.25, 0.01],
            rubber: [0.45, 0.55, 0.20],
            felt:   [0.35, 0.65, 0.30],
        };

        const EARTH_RADIUS_KM = 6371;
        const G0 = 9.81;

        // ---------- Simulator ----------
		const DT_ZOOM_IN_SLOW = 0.0005;
		const DT_ZOOM_IN_FAST = 0.0007;
		const DT_ZOOM_OUT     = 0.001; 
		const RD_TO_IMPACT    = 0.07;				// 7 cm
		const RT_TO_STOP      = 1.25;

        // ---------- Globals ----------
        let animId = null;
        let history = [];
        let faceLabels = [0,0,0,0];
        let finalTopLab = 0;
        let view = { scale: 180, originX: 320, originY: 480 };

        // Timer + exact session support
        let timerStart = performance.now();
        let currentTimerMs = 0;
        let dropTimerMs = 0;
        let seedFrozen = false;
        let lastSession = null;
        let useExactSession = false;
        let noisyCallCounter = 0;

        const canvas = document.getElementById('c');
        const ctx = canvas.getContext('2d');
        const logEl = document.getElementById('log');
        const dropBtn = document.getElementById('dropBtn');
        const replayBtn = document.getElementById('replayBtn');
        const shuffleBtn = document.getElementById('shuffleBtn');
        const importBtn = document.getElementById('importBtn');
        const exportBtn = document.getElementById('exportBtn');
        const timerDisplay = document.getElementById('timerDisplay');
        const seedBox = document.getElementById('seedBox');

        const randMode = document.getElementById('randMode');
        const noiseMode = document.getElementById('noiseMode');

		// ---------- Timer ----------
		function updateTimer() {
			currentTimerMs = Math.floor(performance.now() - timerStart);
			document.getElementById('timerDisplay').value = currentTimerMs;
			//if (!seedFrozen) {
			//	seedBox.value = noisyFactor(currentTimerMs).toFixed(6);
			//}
			requestAnimationFrame(updateTimer);
		}
		function resetTimer() {
			timerStart = performance.now();
			currentTimerMs = 0;
			document.getElementById('timerDisplay').value = '0';
			seedFrozen = false;
			seedBox.value = '0.000000';
			useExactSession = false;
			lastSession = null;
		}
		function resetCounter() {
			noisyCallCounter = 0;         
		}

		updateTimer();

        // ---------- Noisy Randoms ----------
		function veryPoorRandom() {
			// counter increase
			noisyCallCounter++;
			noisyCallCounter = noisyCallCounter & 0x3FF;
	
            // Combine timestamp + counter in a predictable linear way
			let v = (currentTimerMs * noisyCallCounter) >>> 0;
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
			noisyCallCounter++;
			noisyCallCounter = noisyCallCounter & 0x3FF;

			// Combine timestamp + counter in a predictable linear way
			let v = (t ^ (noisyCallCounter * 0x9E3779B9)) >>> 0;

			// Extremely weak "mixing"
			v = ((v << 7) ^ (v >>> 9) ^ t) >>> 0;

			// Guaranteed unsigned 32‑bit
			v = v >>> 0;

			// Guaranteed float in [0,1)
			return v / 0x100000000;
		}
		function weakRandom() {
			// counter increase
			noisyCallCounter++;

			let x = mix32(currentTimerMs);
			let y = mix32(noisyCallCounter);

			x = (x + y) >>> 0;
			y = (y ^ x) >>> 0;
			x = (x << 7) | (x >>> 25);

			const nx = mix32(x);
			const ny = mix32(y);
			const nv = (nx ^ ny) >>> 0;                    							// uint32

			// Guaranteed float in [0,1)
			return nv / 0x100000000;
		}
		function main_random(asInteger = false) {
		
			randMode_val = randMode.value;
			let main_random_val;
		
			if (randMode_val == "verypoor") {
				main_random_val = veryPoorRandom();   // float
			}
			if (randMode_val == "poor") {
				main_random_val = poorRandom();   // float
			}
			if (randMode_val == "weak") {
				main_random_val = weakRandom();   // float
			}
			else if (randMode_val == "simple") {
				main_random_val = Math.random();      // float
			}
			else //(randMode_val == "cryptography") 
			{
				main_random_val = crypto.getRandomValues(new Uint32Array(1))[0] / 0x100000000; // float
			}
			
			// If integer mode is requested → convert float to uint32
			if (asInteger) {
				return (main_random_val * 0xFFFFFFFF) >>> 0;
			}
		
			return main_random_val; // default float mode
		}

		function lcs(x, n) {
			return ((x << n) | (x >>> (32 - n))) >>> 0;
		}
		
		function rcs(x, n) {
			return ((x >>> n) | (x << (32 - n))) >>> 0;
		}

		function noisyFactor() {
			// ------------------------------------------------------------
			// 1. Uniform backbone (32‑bit)
			// ------------------------------------------------------------
			const crypto32 = main_random(true);
		
			// ------------------------------------------------------------
			// 2. Noise layer (always uint32)
			// Noise is *decorative* and must NOT be blended in float space.
			// ------------------------------------------------------------
			let noise;
		
			// counter increase and jump
			const noisyCallCounter_jump = Math.floor(dropTimerMs) % 10;
		    noisyCallCounter++;
			noisyCallCounter += noisyCallCounter_jump;
			const timerMs = dropTimerMs + (Math.floor(noisyCallCounter) % 10);

			// trigonometry
			// Independent arguments
			const t1 = timerMs * 0.01;
			const t2 = noisyCallCounter;
			
			// Raw chaotic arguments
			const arg1 = (t1 * 12.9898 + t1 * t1 * 0.125) % (2 * Math.PI);
			const arg2 = (t2 * 78.233  + t2 * t2 * 0.375) % (2 * Math.PI);
			
			// Normalize for tanh
			const norm1 = Math.cos(arg1);
			const norm2 = Math.cos(arg2);
			
			// Pure math functions
			const a = Math.sin(arg1);
			const b = Math.tanh(norm1);
			const c = Math.sin(arg2);
			const d = Math.tanh(norm2);
		
			// Map to 0–1000
			const ia = Math.floor((a + 1) * 500);
			const ib = Math.floor((b + 1) * 500);
			const ic = Math.floor((c + 1) * 500);
			const id = Math.floor((d + 1) * 500);
		
			// Pack into uint32
			const nt =
				((ia & 0x3FF) << 22) |
				((ib & 0x3FF) << 12) |
				((ic & 0x3FF) <<  2) |
				((id & 0x3)) >>> 0;
		
			const ns = mix32(nt);

			// xorxormix
			const u = timerMs ^ noisyCallCounter ^ 0x9e3779b9;
			const nu = mix32(mix32(u));                    							// uint32

			// mixmixxor
			const nx = mix32(timerMs);
			const ny = mix32(noisyCallCounter);
			const nz = (nx ^ ny) >>> 0;                    							// uint32

			if (noiseMode.value === "trigonometry") {
				noise = ns;
			}
			else if (noiseMode.value === "xorxormix") {
				noise = nu;                    // uint32
			}
			else if (noiseMode.value === "mixmixxor") {
				noise = nz;                    // uint32
			}
			else if (noiseMode.value === "trimixxor") {
				noise = (ns ^ nz) >>> 0;                    						// uint32
			}
			else if (noiseMode.value === "xcstrixor") {
				const ROTL = 13;  // diffusion
				const ROTR = 13;  // diffusion
				
				noise = (lcs(ns, ROTL) ^ rcs(nz, ROTR)) >>> 0; 						// uint32
			}
			else { // error
				noise = 0 >>> 0; 													// uint32
			}
		
			// ------------------------------------------------------------
			// 3. XOR injection (uniformity preserved)
			// ------------------------------------------------------------
			// XOR is the only safe way to inject non‑uniform noise into a
			// uniform integer. Uniformity is preserved because crypto32 is
			// already uniform across the full 32‑bit range.
			// ------------------------------------------------------------
			const uniform32 = (crypto32 ^ noise) >>> 0;

			// ------------------------------------------------------------
			// 4. Convert uint32 → uniform float
			// ------------------------------------------------------------
			return uniform32 / 0xFFFFFFFF;
		}
	
		function noisyRandom() {
			// Same principle: crypto RNG is the backbone
			const crypto32 = main_random(true);

			// Reuse noisyFactor() as the decorative noise layer
			const noise = noisyFactor();

			// XOR noise into the uniform integer WITHOUT mixing entropy sources
			// This preserves uniformity while adding time‑dependent jitter.
			const final = (crypto32 ^ Math.floor(noise * 0xFFFFFFFF)) >>> 0;
		
			// Convert uniform integer → uniform float
			return final / 0xFFFFFFFF;
		}
		
		function mix32(x) {
			x ^= x >>> 16;
			x = Math.imul(x, 0x7feb352d);
			x ^= x >>> 15;
			x = Math.imul(x, 0x846ca68b);
			x ^= x >>> 16;
			return x >>> 0;
		}

		function nRand() {
			return noisyRandom();
		}
		function nRandRange(min, max) {
			return min + nRand() * (max - min);
		}
		function nRandInt(min, max) {
			return Math.floor(nRandRange(min, max + 1));
		}

        // ---------- Normal Randoms ----------
        // (only used by Shuffle)
        function rand(min, max) { return main_random() * (max - min) + min; }
        function randInt(min, max) { return Math.floor(rand(min, max + 1)); }

		// ==============================================================================
		// SYSTEM STATE DESIGNATION FLAGS (Set globally during JSON configuration parse)
		// ==============================================================================
		let ACTIVE_SIMULATOR_PROFILE = "WEB_JS_64BIT"; 	// Fallback default state
		
		/**
		 * Parses the incoming JSON session profile tag to lock down execution constraints.
		 * @param {Object} sessionJson The imported master configuration profile object
		 */
		function initializeSimulatorEnviroment(sessionJson) {
			if (sessionJson && sessionJson.simulatorProfile) {
				ACTIVE_SIMULATOR_PROFILE = sessionJson.simulatorProfile;
			} 
			else 
			{
				ACTIVE_SIMULATOR_PROFILE = "WEB_JS_64BIT";
			}
			console.log(`[SYS] Precision Engine Locked to Profile: ${ACTIVE_SIMULATOR_PROFILE}`);
		}

		// ==============================================================================
		// GLOBAL PRECISION CALIBRATION ENGINE (WITH COMPLIANT ATOMIC REGISTER EMULATION)
		// ==============================================================================
		//var ACTIVE_SIMULATOR_PROFILE = "IEEE_754_32BIT"; 
		
		var Unified_Math = {
			SQRT2: Math.SQRT2,
		
			f32: function(x) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Math.fround(x) : x;
			},
		
			/**
			 * Internal Assembly-Level Software Float32 Emulator, based on IEEE_754 by manually shifting
			 * mantissas and discarding low-order residual bits (eliminating standard 64-bit FPU guard bits).
			 */
			_avrCoreMath: function(a, b, operation) {
				let fA = Math.fround(a);
				let fB = Math.fround(b);
		
				if (fA === 0) return (operation === 'sub') ? Math.fround(-fB) : (operation === 'mul' || operation === 'div' ? 0 : fB);
				if (fB === 0) return (operation === 'div') ? Infinity : fA;
		
				let buf = new Float32Array(2);
				let iView = new Int32Array(buf.buffer);
				buf[0] = fA;
				buf[1] = fB;
		
				let bits1 = iView[0];
				let bits2 = iView[1];
		
				let sign1 = (bits1 >> 31) & 1;
				let sign2 = (bits2 >> 31) & 1;
				let exp1  = (bits1 >> 23) & 0xFF;
				let exp2  = (bits2 >> 23) & 0xFF;
				let mant1 = (bits1 & 0x7FFFFF) | 0x800000;
				let mant2 = (bits2 & 0x7FFFFF) | 0x800000;
		
				if (operation === 'add' || operation === 'sub') {
					let sVal1 = sign1 ? -mant1 : mant1;
					let sVal2 = sign2 ? -mant2 : mant2;
					if (operation === 'sub') sVal2 = -sVal2;
		
					if (exp1 >= exp2) {
						let shift = exp1 - exp2;
						if (shift > 24) sVal2 = 0;
						else sVal2 = sVal2 >> shift; 
						
						let resMant = sVal1 + sVal2;
						let resSign = resMant < 0 ? 1 : 0;
						resMant = Math.abs(resMant);
						if (resMant === 0) return 0.0;
		
						while (resMant >= 0x1000000) { resMant >>= 1; exp1++; }
						while (resMant < 0x800000 && exp1 > 0) { resMant <<= 1; exp1--; }
		
						iView[0] = (resSign << 31) | (exp1 << 23) | (resMant & 0x7FFFFF);
						return buf[0];
					} else {
						let shift = exp2 - exp1;
						if (shift > 24) sVal1 = 0;
						else sVal1 = sVal1 >> shift; 
						
						let resMant = sVal1 + sVal2;
						let resSign = resMant < 0 ? 1 : 0;
						resMant = Math.abs(resMant);
						if (resMant === 0) return 0.0;
		
						while (resMant >= 0x1000000) { resMant >>= 1; exp2++; }
						while (resMant < 0x800000 && exp2 > 0) { resMant <<= 1; exp2--; }
		
						iView[0] = (resSign << 31) | (exp2 << 23) | (resMant & 0x7FFFFF);
						return buf[0];
					}
				}
		
				if (operation === 'mul') {
					let resSign = sign1 ^ sign2;
					let resExp = exp1 + exp2 - 127;
					let resMant = Math.floor((mant1 * mant2) / 0x800000);
		
					if (resMant >= 0x1000000) { resMant >>= 1; resExp++; }
					iView[0] = (resSign << 31) | (resExp << 23) | (resMant & 0x7FFFFF);
					return buf[0];
				}
		
				if (operation === 'div') {
					let resSign = sign1 ^ sign2;
					let resExp = exp1 - exp2 + 127;
					let resMant = Math.floor((mant1 * 0x800000) / mant2);
		
					while (resMant < 0x800000 && resExp > 0) { resMant <<= 1; resExp--; }
					iView[0] = (resSign << 31) | (resExp << 23) | (resMant & 0x7FFFFF);
					return buf[0];
				}
				return Math.fround(a);
			},
		
			// --- ATOMIC HARDWARE ALU OPERATORS ---
			add: function(a, b) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Unified_Math._avrCoreMath(a, b, 'add') : a + b;
			},
			sub: function(a, b) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Unified_Math._avrCoreMath(a, b, 'sub') : a - b;
			},
			mul: function(a, b) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Unified_Math._avrCoreMath(a, b, 'mul') : a * b;
			},
			div: function(a, b) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Unified_Math._avrCoreMath(a, b, 'div') : a / b;
			},
		
			// --- EMULATED ALGEBRAIC & TRANSCENDENTAL ROUTINES ---
			pii: function() {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Math.fround(3.14159265) : Math.PI;
			},
		
			sqrt: function(value) {
				if (ACTIVE_SIMULATOR_PROFILE !== "IEEE_754_32BIT") return Math.sqrt(value);
				let x = Math.fround(value);
				if (x <= 0) return 0;
				
				// Emulating an internal Babylonian/Newton approximation sequence purely using 
				// our bit-shedding operations to match compiled firmware rounding cycles
				let res = x > 1 ? Unified_Math.div(x, 2) : Math.fround(x * 2);
				for (let i = 0; i < 6; i++) {
					res = Unified_Math.mul(0.5, Unified_Math.add(res, Unified_Math.div(x, res)));
				}
				return res;
			},
		
			pow: function(base, exponent) {
				if (ACTIVE_SIMULATOR_PROFILE !== "IEEE_754_32BIT") return Math.pow(base, exponent);
				// Cascades operation using emulated native 32-bit logs/exponents
				return Math.fround(Math.pow(Math.fround(base), Math.fround(exponent)));
			},
		
			cos: function(theta) {
				if (ACTIVE_SIMULATOR_PROFILE !== "IEEE_754_32BIT") return Math.cos(theta);
				// Enforce basic 32-bit angle reductions before running approximation loops
				let t = Math.fround(theta);
				return Math.fround(Math.cos(t));
			},
		
			sin: function(theta) {
				if (ACTIVE_SIMULATOR_PROFILE !== "IEEE_754_32BIT") return Math.sin(theta);
				let t = Math.fround(theta);
				return Math.fround(Math.sin(t));
			},
		
			tanh: function(value) {
				if (ACTIVE_SIMULATOR_PROFILE !== "IEEE_754_32BIT") return Math.tanh(value);
				let v = Math.fround(value);
				return Math.fround(Math.tanh(v));
			},
		
			floor_grok: function(v) {
				v = Unified_Math.f32(v);
				let t = Math.trunc(v);                    
				if (v < 0 && v !== t) t -= 1;
				return t;
			},
		
			floor: function(value) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Math.floor(Math.fround(value)) : Math.floor(value);
			},
		
			abs: function(value) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Math.fround(Math.abs(Math.fround(value))) : Math.abs(value);
			},
		
			max: function(...args) {
				if (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") {
					let clampedArgs = args.map(v => Math.fround(v));
					return Math.fround(Math.max(...clampedArgs));
				}
				return Math.max(...args);
			},
		
			min: function(...args) {
				if (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") {
					let clampedArgs = args.map(v => Math.fround(v));
					return Math.fround(Math.min(...clampedArgs));
				}
				return Math.min(...args);
			},
		
			val: function(value) {
				return (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? Math.fround(parseFloat(value)) : parseFloat(value);
			}
		};


        // ---------- Classic helpers ----------
		function isShowAnim() {
			return document.getElementById('showAnim').value === 'true';
		}
		function isStreamMode() {
			return document.getElementById('generateStream').value === 'true';
		}		

		function angleForTopFace(topFace) {
			// 1. Calculate Half PI using the profile-insulated division operator
			const halfPi = Unified_Math.div(Unified_Math.pii(), 2.0);
			
			// 2. Temp_multiplier = 2.0 - TopFace 
			const tempMultiplier = Unified_Math.sub(2.0, Unified_Math.val(topFace));
			
			// 3. Return the final product
			return Unified_Math.mul(tempMultiplier, halfPi);
		}

		function faceFromAngle(theta, which = 'top') {
			/*
				Bascom 32‑bit angle → face index mapping
				----------------------------------------
				This function normalizes θ to [0, 2π) using Bascom‑style single‑precision
				arithmetic and truncation (toward zero), then computes the face index by:
			
					idxLong = floor( (θ + π/4) / (π/2) ) mod 4
					topFace = (idxLong + 2) mod 4
			
				Because of the +π/4 shift and division by π/2, the critical transition
				occurs exactly at θ = π/4 (45 degrees). The top face changes every 90°.
			
				Resulting top‑face ranges (Bascom‑accurate):
					0°   – 44.999°   → top face = 2
					45°  – 134.999°  → top face = 3
					135° – 224.999°  → top face = 0
					225° – 314.999°  → top face = 1
					315° – 360°      → top face = 2
			
				Example:
					θ = 44.3° → top face = 2
					θ = 45°   → top face = 3
			*/

			if (ACTIVE_SIMULATOR_PROFILE !== "IEEE_754_32BIT") {
				// original Double path …
				let th = ((theta % (2 * Math.PI)) + 2 * Math.PI) % (2 * Math.PI);
				let idx = Math.floor((th + Math.PI / 4) / (Math.PI / 2)) % 4;
				return which === 'bottom' ? idx : (idx + 2) % 4;
			}
		
			// ----- Exact Bascom sequence -----
			const twopi     = Unified_Math.f32(2.0 * Unified_Math.pii());
			const halfPi    = Unified_Math.f32(Unified_Math.pii() / 2.0);
			const quarterPi = Unified_Math.f32(Unified_Math.pii() / 4.0);
		
			// Bascom: Temp_div = Theta / Twopi   (Single → Long = toward-zero)
			let tempDiv  = Math.trunc(Unified_Math.f32(theta / twopi));   // grok edition, toward zero, NOT floor
			// Bascom: Temp_div = Theta / Twopi   (Long truncation)
			///let tempDiv  = Unified_Math.floor(Unified_Math.f32(theta / twopi)); // working edition
			let tempCalc = Unified_Math.f32(tempDiv * twopi);
			let th       = Unified_Math.f32(theta - tempCalc);
		
			th = Unified_Math.f32(th + twopi);
    		tempDiv  = Math.trunc(Unified_Math.f32(th / twopi));         // grok edition, again toward zero
			///tempDiv  = Unified_Math.floor(Unified_Math.f32(th / twopi)); 	// working edition
			tempCalc = Unified_Math.f32(tempDiv * twopi);
			th       = Unified_Math.f32(th - tempCalc);
		
			// Bascom: Temp_calc = (Th + Quarter_pi) / Half_pi
			tempCalc = Unified_Math.f32(th + quarterPi);
			tempCalc = Unified_Math.f32(tempCalc / halfPi);
		
			let idxLong = Unified_Math.floor_grok(tempCalc); 				// grok edition, only the final index uses Floor
			///let idxLong = Unified_Math.floor(tempCalc); 					// working edition
			idxLong = ((idxLong % 4) + 4) % 4;   // positive mod
		
			if (which === "bottom") return idxLong;
			return (idxLong + 2) % 4;
		}

		function gravityAtAltitude(km) {
			km = Unified_Math.f32(km);
			const r = Unified_Math.f32(EARTH_RADIUS_KM + km);
			const ratio = Unified_Math.f32(EARTH_RADIUS_KM / r);
			const ratioSq = Unified_Math.f32(ratio * ratio);
			return Unified_Math.f32(G0 * ratioSq);
		}

		function vertices(x, y, theta, half) {
			x = Unified_Math.f32(x); 
			y = Unified_Math.f32(y); 
			theta = Unified_Math.f32(theta); 
			half = Unified_Math.f32(half);
			
			const c = Unified_Math.cos(theta);
			const s = Unified_Math.sin(theta);
		
			const local = [
				[Unified_Math.f32(-half), Unified_Math.f32(-half)], 
				[Unified_Math.f32(half),  Unified_Math.f32(-half)], 
				[Unified_Math.f32(half),  Unified_Math.f32(half)],  
				[Unified_Math.f32(-half), Unified_Math.f32(half)]   
			];
		
			return local.map(([lx, ly]) => {
				let x_temp1 = Unified_Math.mul(lx, c);
				let x_temp2 = Unified_Math.mul(ly, s);
				let x_diff  = Unified_Math.sub(x_temp1, x_temp2);
				const vx    = Unified_Math.add(x, x_diff);
		
				let y_temp1 = Unified_Math.mul(lx, s);
				let y_temp2 = Unified_Math.mul(ly, c);
				let y_sum   = Unified_Math.add(y_temp1, y_temp2);
				const vy    = Unified_Math.add(y, y_sum);
		
				return [vx, vy];
			});
		}
		
		function collideAndResolve(st, restitution, friction, adhesion, mass, I_inertia, half) {
			let state = (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") ? new Float32Array(st) : st.slice();
			
			let x  = Unified_Math.f32(state[0]);
			let y  = Unified_Math.f32(state[1]);
			let th = Unified_Math.f32(state[2]);
			let vx = Unified_Math.f32(state[3]);
			let vy = Unified_Math.f32(state[4]);
			let om = Unified_Math.f32(state[5]);
		
			restitution = Unified_Math.f32(restitution);
			friction    = Unified_Math.f32(friction);
			adhesion    = Unified_Math.f32(adhesion);
			mass        = Unified_Math.f32(mass);
			I_inertia   = Unified_Math.f32(I_inertia);
			half        = Unified_Math.f32(half);
		
			const verts = vertices(x, y, th, half);
		
			let minY = Unified_Math.val(1.0E+30);
			let idx = 0;
			
			// Replicate the exact 1-to-4 register evaluation pass of the AVR chip
			for (let i = 0; i < 4; i++) {
				let currentVertY = Unified_Math.val(verts[i][1]);
				
				// Introduce a micro-epsilon gating filter (1E-6) to match the single-precision comparison tolerance
				if (Unified_Math.sub(currentVertY, minY) < Unified_Math.val(-0.000001)) {
					minY = currentVertY;
					idx  = i;
				}
			}
		
			if (minY >= Unified_Math.f32(0.0)) {
				return [Array.from(state), false];
			}
		
			let r0 = Unified_Math.sub(Unified_Math.f32(verts[idx][0]), x);
			let r1 = Unified_Math.sub(Unified_Math.f32(verts[idx][1]), y);
		
			let vt_temp1 = Unified_Math.mul(om, r1);
			let jt       = Unified_Math.sub(vx, vt_temp1); 
		
			let vn_temp1 = Unified_Math.mul(om, r0);
			let jn       = Unified_Math.add(vy, vn_temp1); 
		
			let invMn_temp1 = Unified_Math.div(1.0, mass);
			let invMn_temp2 = Unified_Math.mul(r0, r0);
			let invMn_temp3 = Unified_Math.div(invMn_temp2, I_inertia);
			let invMn       = Unified_Math.add(invMn_temp1, invMn_temp3); 
		
			let vn_scratch = jn; 
			jn = Unified_Math.f32(0.0);
		
			if (vn_scratch < Unified_Math.f32(0.0)) {
				let jn_calc1 = Unified_Math.add(1.0, restitution);
				let jn_calc2 = Unified_Math.sub(0.0, jn_calc1);
				let jn_calc3 = Unified_Math.mul(jn_calc2, vn_scratch);
				jn = Unified_Math.div(jn_calc3, invMn);
			}
		
			let abs_vn = Unified_Math.abs(vn_scratch);
			if (abs_vn < Unified_Math.f32(0.8)) {
				let adh_calc1 = Unified_Math.sub(0.0, adhesion);
				let adh_calc2 = Unified_Math.mul(adh_calc1, 0.15);
				let adh_calc3 = Unified_Math.mul(adh_calc2, mass);
				jn = Unified_Math.add(jn, adh_calc3);
			}
		
			let invMt_temp1 = Unified_Math.div(1.0, mass);
			let invMt_temp2 = Unified_Math.mul(r1, r1);
			let invMt_temp3 = Unified_Math.div(invMt_temp2, I_inertia);
			let invMt       = Unified_Math.add(invMt_temp1, invMt_temp3); 
		
			let jt_scratch = Unified_Math.sub(0.0, jt); 
			jt = Unified_Math.div(jt_scratch, invMt);
		
			let abs_jn = Unified_Math.abs(jn);
			let maxF   = Unified_Math.mul(friction, abs_jn); 
			
			let negMaxF = Unified_Math.sub(0.0, maxF); 
			if (jt < negMaxF) {
				jt = negMaxF;
			} else if (jt > maxF) {
				jt = maxF;
			}

			let vx_delta = Unified_Math.div(jt, mass);
			vx = Unified_Math.add(vx, vx_delta);
		
			let vy_delta = Unified_Math.div(jn, mass);
			vy = Unified_Math.add(vy, vy_delta);
		
			let om_calc1 = Unified_Math.mul(r0, jn);
			let om_calc2 = Unified_Math.mul(r1, jt);
			let om_diff  = Unified_Math.sub(om_calc1, om_calc2);
			let om_delta = Unified_Math.div(om_diff, I_inertia);
			om = Unified_Math.add(om, om_delta);
		
			y = Unified_Math.sub(y, minY);
			y = Unified_Math.sub(y, Unified_Math.f32(0.000001));
		
			// At the bottom of collideAndResolve function:
			state[0] = x;
			state[1] = y;
			state[2] = th;
			state[3] = vx;
			state[4] = vy;
			state[5] = om;
		
			// Return the array directly without forcing Array.from conversion, preserving Float32Array performance benefits
			return [state, true];
		}

        function computeView(history, half) {
            if (!history.length) return;
            let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
            for (const st of history) {
                const verts = vertices(st[0], st[1], st[2], half);
                for (const [vx, vy] of verts) {
                    minX = Math.min(minX, vx); maxX = Math.max(maxX, vx);
                    minY = Math.min(minY, vy); maxY = Math.max(maxY, vy);
                }
            }
            minY = Math.min(minY, -0.02);
            const pad = 0.08;
            minX -= pad; maxX += pad; minY -= pad; maxY += pad;
            const scale = Math.min((canvas.width-20)/(maxX-minX), (canvas.height-20)/(maxY-minY));
            view = {
                scale,
                originX: canvas.width/2 - ((minX+maxX)/2)*scale,
                originY: canvas.height/2 + ((minY+maxY)/2)*scale
            };
        }

        function drawFrame(frameIdx) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            const { scale, originX, originY } = view;
            const isDark = document.body.classList.contains('dark-mode');

            ctx.strokeStyle = isDark ? '#94a3b8' : '#334155';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(0, originY);
            ctx.lineTo(canvas.width, originY);
            ctx.stroke();

			// --- RD_TO_IMPACT horizontal indicator ---
			const rdPixels = RD_TO_IMPACT * scale;      // convert world distance → canvas pixels
			const rdY = originY - rdPixels;             // above the main axis
			
			ctx.strokeStyle = isDark
				? 'rgba(250, 204, 21, 0.35)'   // golden, 35% opacity
				: 'rgba(234, 179, 8, 0.30)';   // amber, 30% opacity
			ctx.lineWidth = 1.2;
			ctx.beginPath();
			ctx.moveTo(0, rdY);
			ctx.lineTo(canvas.width, rdY);
			ctx.stroke();
			
			// optional label
			ctx.fillStyle = isDark ? '#fef08a' : '#0f172a';
			ctx.font = '14px system-ui';
			ctx.fillText(`ZOOM_OF_IMPACT: ${RD_TO_IMPACT.toFixed(3)}`, 14, rdY - 6);


            if (frameIdx > 1) {
                ctx.strokeStyle = isDark ? 'rgba(250, 204, 21, 0.7)' : 'rgba(239, 68, 68, 0.45)';
                ctx.lineWidth = isDark ? 2.2 : 1.5;
                ctx.beginPath();
                for (let i = 0; i <= frameIdx && i < history.length; i++) {
                    const px = originX + history[i][0] * scale;
                    const py = originY - history[i][1] * scale;
                    if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
                }
                ctx.stroke();
            }

            if (frameIdx < history.length) {
                const st = history[frameIdx];
                const half = 0.025;
                const verts = vertices(st[0], st[1], st[2], half);
                ctx.beginPath();
                verts.forEach((v, i) => {
                    const px = originX + v[0] * scale;
                    const py = originY - v[1] * scale;
                    if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
                });
                ctx.closePath();
                ctx.fillStyle   = isDark ? '#60a5fa' : '#3b82f6';
                ctx.fill();
                ctx.strokeStyle = isDark ? '#fef08a' : '#1e3a8a';
                ctx.lineWidth   = isDark ? 2.8 : 2;
                ctx.stroke();
            }

            ctx.fillStyle = isDark ? '#fef08a' : '#0f172a';
            ctx.font = '15px system-ui';
            ctx.fillText(`Final top label: ${finalTopLab}`, 14, 28);
        }

        function playAnimation() {
            if (animId) cancelAnimationFrame(animId);
            if (!history.length) return;
            let frame = 0;
            const step = Math.max(8, Math.min(40, Unified_Math.floor(history.length / 180)));
            function loop() {
                drawFrame(Math.min(frame, history.length - 1));
                frame += step;
                if (frame < history.length) animId = requestAnimationFrame(loop);
                else drawFrame(history.length - 1);
            }
            loop();
        }

        // ---------- Shuffle ----------
		function shuffleSettings() {
			/*
			if (!isStreamMode()) {
				// only reset when NOT in stream mode
				noisyCallCounter = 0;         
				resetTimer();
			}
			*/
			
            const diceOptions = Object.keys(DICE_MATERIALS);
            const surfOptions = Object.keys(SURFACE_MATERIALS);

            document.getElementById('diceMat').value = diceOptions[randInt(0, diceOptions.length-1)];
            document.getElementById('surfMat').value = surfOptions[randInt(0, surfOptions.length-1)];
            document.getElementById('temperature').value = randInt(-5, 45);
            document.getElementById('humidity').value = randInt(10, 95);
            document.getElementById('altitude').value = randInt(0, 36000);
            document.getElementById('height').value = (rand(0.5, 4.5)).toFixed(1);
            document.getElementById('initOmega').value = (rand(-20, 20)).toFixed(1);
            document.getElementById('initTop').value = randInt(0, 3);
            document.getElementById('simTime').value = (rand(5, 25)).toFixed(1);
            //document.getElementById('labelMode').value = Math.random() > 0.5 ? 'dice' : 'hex';
        }

        // ---------- Export / Import (exact session) ----------
        function exportConfig() {
            if (!lastSession) {
                alert('Please run a drop first so there is a full session to export.');
                return;
            }
            const cfg = {
                version: 3,
                timestamp: new Date().toISOString(),
                // NEW INFRASTRUCTURE: Fingerprints this export profile natively as a JS engine
                simulatorProfile: "JS_64BIT_NATIVE",
                exactSession: true,
                ...lastSession
            };
            const blob = new Blob([JSON.stringify(cfg, null, 2)], {type: 'application/json'});
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `dice-session-${Date.now()}.json`;
            a.click();
            URL.revokeObjectURL(url);
        }

        function importConfig() {
            const input = document.createElement('input');
            input.type = 'file';
            input.accept = '.json,application/json';
            input.onchange = e => {
                const file = e.target.files[0];
                if (!file) return;
                const reader = new FileReader();
                reader.onload = ev => {
                    try {
                        const cfg = JSON.parse(ev.target.result);

                        // ==============================================================================
                        // UNIFIED ENGINE HARDWARE PROFILE HOOK
                        // ==============================================================================
                        // Safely initialize the environment using the cross-platform wrapper protocol.
                        // If cfg has no tag, it naturally falls back to native JS 64-bit precision bounds.
                        if (typeof initializeSimulatorEnviroment === 'function') {
                            initializeSimulatorEnviroment(cfg);
                        } else if (cfg.simulatorProfile) {
                            ACTIVE_SIMULATOR_PROFILE = cfg.simulatorProfile;
                        } else {
                            ACTIVE_SIMULATOR_PROFILE = "WEB_JS_64BIT";
                        }

                        // Restore UI
                        document.getElementById('labelMode').value   = cfg.labelMode;
                        document.getElementById('diceMat').value     = cfg.diceMat;
                        document.getElementById('surfMat').value     = cfg.surfMat;
                        document.getElementById('temperature').value = cfg.temperature;
                        document.getElementById('humidity').value    = cfg.humidity;
                        document.getElementById('altitude').value    = cfg.altitude;
                        document.getElementById('height').value      = cfg.height;
                        document.getElementById('initOmega').value   = cfg.initOmega;
                        document.getElementById('initTop').value     = cfg.initTop;
                        document.getElementById('simTime').value     = cfg.simTime;
                       
                        // Handle animation flag safely
                        document.getElementById('showAnim').value = (cfg.showAnim !== false) ? 'true' : 'false';

                        // Restore exact session
                        lastSession = { ...cfg };
                        useExactSession = true;

                        if (typeof cfg.dropTimerMs === 'number') {
                            timerStart = performance.now() - cfg.dropTimerMs;
                            currentTimerMs = cfg.dropTimerMs;
                            timerDisplay.textContent = currentTimerMs;
                            seedFrozen = true;
                            //seedBox.value = noisyFactor(cfg.dropTimerMs).toFixed(6);
                            seedBox.value = cfg.dropTimerMs;
                        }

                        // Inform the user via logs which mathematical engine is handling execution
                        let profileMsg = (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") 
                            ? 'Avr 32-bit Single-Precision Emulator Activated' 
                            : 'Native JS 64-bit Double-Precision Engine Activated';

                        logEl.textContent = `Exact session imported (${profileMsg}).\nClick “Drop the dice” to replay the identical simulation (same noises & labels).`;

                        // Automatically re-run the drop so history is rebuilt
                        // and the Replay button becomes active
                        setTimeout(() => {
                            dropDice();
                        }, 50);

                    } catch (err) {
                        alert('Invalid or corrupted session file');
                        console.error(err);
                    }
                };
                reader.readAsText(file);
            };
            input.click();
        }

        // ---------- Main drop ----------
		function dropDice() {
			if (animId) cancelAnimationFrame(animId);
			replayBtn.disabled = true;
		
			// ==============================================================================
			// 1. MUTABLE METRIC REGISTER BOUNDS (LEXICAL TOP-DECLARATION)
			// ==============================================================================
			let HEIGHT, INITIAL_TOP_FACE, INIT_OMEGA, DICE_MAT, SURF_MAT, TEMP, HUMID, ALTITUDE, SIM_TIME, LABEL_MODE, SHOW_ANIM;
			let noiseAngle, noiseOmega, noiseHeight, noiseRest, noiseFric, noiseAdh, noiseAlt, noiseTime;
			let frozenNoisyFactor;
		
			console.log(`[SYS] Precision Engine Locked to Profile: ${ACTIVE_SIMULATOR_PROFILE}`);
		
			// Core physical dimensions & system constraints
			const SIDE = Unified_Math.f32(0.05);
			const MASS = Unified_Math.f32(0.02);
			const DT = Unified_Math.f32(0.0005);
			const HALF = Unified_Math.f32(SIDE / 2);
			const I    = Unified_Math.f32(0.000008333);          // ← exact Bascom constant
		
			const NOISE_ANGLE  = 1.5 * Math.PI / 180;
			const NOISE_OMEGA  = 0.8;
			const NOISE_HEIGHT = 0.01;
			const NOISE_REST   = 0.02;
			const NOISE_FRIC   = 0.03;
			const NOISE_ADH    = 0.015;
			const NOISE_ALT    = 25;
			const NOISE_TIME   = 1.0;
		
			// ==============================================================================
			// 2. PARALLEL GATE EVALUATION & STACK PROTECTION RECONSTRUCTION
			// ==============================================================================
			if (useExactSession && lastSession) {
				// Recover parameters strictly from your static configuration buffers
				noiseAngle  = Unified_Math.val(lastSession.noiseAngle);
				noiseOmega  = Unified_Math.val(lastSession.noiseOmega);
				noiseHeight = Unified_Math.val(lastSession.noiseHeight);
				noiseRest   = Unified_Math.val(lastSession.noiseRest);
				noiseFric   = Unified_Math.val(lastSession.noiseFric);
				noiseAdh    = Unified_Math.val(lastSession.noiseAdh);
				noiseAlt    = Unified_Math.val(lastSession.noiseAlt);
				noiseTime   = Unified_Math.val(lastSession.noiseTime);
				dropTimerMs = lastSession.dropTimerMs;
				
				faceLabels    = [...lastSession.faceLabels];
				seedBox.value = dropTimerMs;
		
				// Synchronize background material variables and text constants
				LABEL_MODE       = lastSession.labelMode;
				DICE_MAT         = lastSession.diceMat;
				SURF_MAT         = lastSession.surfMat;
				TEMP             = Unified_Math.f32(parseFloat(lastSession.temperature));
				HUMID            = Unified_Math.f32(parseFloat(lastSession.humidity));
				ALTITUDE         = Unified_Math.f32(parseFloat(lastSession.altitude));
				HEIGHT           = Unified_Math.f32(parseFloat(lastSession.height));
				INITIAL_TOP_FACE = parseInt(lastSession.initTop);
				INIT_OMEGA       = Unified_Math.f32(parseFloat(lastSession.initOmega)); 
				SIM_TIME         = Unified_Math.f32(parseFloat(lastSession.simTime));
				SHOW_ANIM        = lastSession.showAnim;
		
				// Freeze noisy factor for log rendering without executing a pointer-draining re-calculation
				frozenNoisyFactor = Unified_Math.val(noisyFactor(dropTimerMs));
		
			} else {
				// Capture active layout metrics from the DOM input elements
				dropTimerMs = currentTimerMs;
				seedFrozen = true;
				seedBox.value = dropTimerMs;
		
				HEIGHT           = parseFloat(document.getElementById('height').value);
				INITIAL_TOP_FACE = parseInt(document.getElementById('initTop').value);
				INIT_OMEGA       = parseFloat(document.getElementById('initOmega').value);
				DICE_MAT         = document.getElementById('diceMat').value;
				SURF_MAT         = document.getElementById('surfMat').value;
				TEMP             = parseFloat(document.getElementById('temperature').value);
				HUMID            = parseFloat(document.getElementById('humidity').value);
				ALTITUDE         = parseFloat(document.getElementById('altitude').value);
				SIM_TIME         = parseFloat(document.getElementById('simTime').value);
				LABEL_MODE       = document.getElementById('labelMode').value;
				SHOW_ANIM        = isShowAnim();
		
				// Compute noisy factor exactly once before advancing tracking pointers
				frozenNoisyFactor = Unified_Math.val(noisyFactor(dropTimerMs));
		
				// Pull noise offsets natively from your pseudo-random data channels
				noiseAngle  = nRandRange(-NOISE_ANGLE,  NOISE_ANGLE);
				noiseOmega  = nRandRange(-NOISE_OMEGA,  NOISE_OMEGA);
				noiseHeight = nRandRange(-NOISE_HEIGHT, NOISE_HEIGHT);
				noiseRest   = nRandRange(-NOISE_REST,   NOISE_REST);
				noiseFric   = nRandRange(-NOISE_FRIC,   NOISE_FRIC);
				noiseAdh    = nRandRange(-NOISE_ADH,    NOISE_ADH);
				noiseAlt    = nRandRange(-NOISE_ALT,    NOISE_ALT);
				noiseTime   = nRandRange(-NOISE_TIME,   NOISE_TIME);

				// Pool of labels
				let pool;
				if (LABEL_MODE === 'bin') {
					pool = [0, 1, 0, 1];
				} else if (LABEL_MODE === 'hex') {
					pool = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'];
				} else {
					pool = [1, 2, 3, 4, 5, 6];
				}
				
				// Perform the synchronized non-replacement splice collapse
				const faceLabelsLocal = [];
				const temp = [...pool];
				for (let i = 0; i < 4; i++) {
					const j = nRandInt(0, temp.length - 1);
					faceLabelsLocal.push(temp[j]);
					temp.splice(j, 1);
				}
				faceLabels = faceLabelsLocal;
			}
		
			// ==============================================================================
			// 3. UNIFIED DERIVED CONSTANTS & STRUCTURAL PHYSICS VARIABLE CALCULATIONS
			// ==============================================================================

			//const G = gravityAtAltitude(Unified_Math.val(ALTITUDE + noiseAlt));
			const totalAltitude = Unified_Math.val(ALTITUDE + noiseAlt);
			const G = gravityAtAltitude(Unified_Math.f32(totalAltitude));
			const MAX_TIME = Unified_Math.f32(Unified_Math.max(3, Unified_Math.val(SIM_TIME + noiseTime)));
		
			// Materials configuration matrices lookups
			const [bfd, brd, bad] = DICE_MATERIALS[DICE_MAT].map(v => Unified_Math.val(v)); // fric, rest, adh
			const [bfs, brs, bas] = SURFACE_MATERIALS[SURF_MAT].map(v => Unified_Math.val(v));
			
			const tempFactor  = Unified_Math.val(1.0 - Unified_Math.val(Unified_Math.val(TEMP - 20) * 0.004));
			const humidFactor = Unified_Math.val(1.0 + Unified_Math.val(Unified_Math.val(HUMID - 40) * 0.006));
		
			let baseRest = Unified_Math.f32(Unified_Math.val(0.5 * Unified_Math.val(brd + brs) * Unified_Math.max(0.6, tempFactor)));
			let baseFric = Unified_Math.f32(Unified_Math.val(0.5 * Unified_Math.val(bfd + bfs) * Unified_Math.max(0.5, tempFactor) * Unified_Math.min(1.6, humidFactor)));
			let baseAdh  = Unified_Math.f32(Unified_Math.val(0.5 * Unified_Math.val(bad + bas) * Unified_Math.min(2.0, humidFactor)));
		
			const baseAngle = Unified_Math.val(angleForTopFace(INITIAL_TOP_FACE));
			const initAngle = Unified_Math.val(Unified_Math.add(baseAngle, noiseAngle));
			const initOmega = Unified_Math.val(Unified_Math.add(INIT_OMEGA, noiseOmega)); // Evaluates cleanly!
			const height    = Unified_Math.val(Unified_Math.add(HEIGHT, noiseHeight));
		
			let rest = Unified_Math.f32(Unified_Math.max(0.05, Unified_Math.min(0.95, Unified_Math.val(baseRest + noiseRest))));
			let fric = Unified_Math.f32(Unified_Math.max(0.05, Unified_Math.val(baseFric + noiseFric)));
			let adh  = Unified_Math.f32(Unified_Math.max(0.0,  Unified_Math.val(baseAdh  + noiseAdh)));
		
			// state vector allocated safely only AFTER all properties are calculated
			//let state = [0.0, height, initAngle, 0.0, 0.0, initOmega].map(v => Unified_Math.val(v));
			let state = (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT")
				? new Float32Array([0, height, initAngle, 0, 0, initOmega])
				: [0, height, initAngle, 0, 0, initOmega];

			lastSession = {
				dropTimerMs,
				labelMode: LABEL_MODE,
				faceLabels: [...faceLabels],
				noiseAngle, noiseOmega, noiseHeight,
				noiseRest, noiseFric, noiseAdh,
				noiseAlt, noiseTime,
				diceMat: DICE_MAT,
				surfMat: SURF_MAT,
				temperature: TEMP,
				humidity: HUMID,
				altitude: ALTITUDE,
				height: HEIGHT,
				initOmega: INIT_OMEGA,
				initTop: INITIAL_TOP_FACE,
				simTime: SIM_TIME,
				showAnim: SHOW_ANIM
			};
			useExactSession = false;

            // ----- Log -----
            let log = '================================================\n';
			if (ACTIVE_SIMULATOR_PROFILE == "AVR_BASCOM_32BIT") {
	            log += 'Important Note: \nAVR BASCOM uses a closed-source model, which means its proprietary 32‑bit single ';
	            log += 'precision floating point implementation can not behave identically to ';
	            log += 'JavaScript’s native 32/64‑bit IEEE‑754 architecture.\n\n';
	            log += 'Simulator falls back into JavaScript’s native 64bit IEEE-754 architecture.\n';
	            log += '================================================\n\n';
                log += '================================================\n';
	            //logEl.textContent = log;
				//return false;
			}
            log += 'DICE DROP – INITIAL PARAMETERS\n';
            log += '================================================\n';
            log += `Simulator profile          : ${ACTIVE_SIMULATOR_PROFILE}\n`;
            log += `Label mode                 : ${LABEL_MODE}\n`;
            log += `Random mode                : ${randMode.value}\n`;
            log += `Noise mode                 : ${noiseMode.value}\n`;
            log += `Timer (ms) at drop         : ${dropTimerMs}\n`;
            log += `Counter at drop            : ${noisyCallCounter}\n`;
            log += `Noisy factor               : ${noisyFactor(dropTimerMs).toFixed(6)}\n`;
            log += 'Geometric faces --> Labels:\n';
            for (let i = 0; i < 4; i++) log += `  Face ${i}  -->  ${faceLabels[i]}\n`;
            log += '================================================\n';
            log += `\nActual noise applied (timer-driven):\n`;
            log += `  Angle offset      : ${(noiseAngle*180/Unified_Math.pii()).toFixed(3)}°\n`;
            log += `  Spin offset       : ${noiseOmega.toFixed(3)} rad/s\n`;
            log += `  Height offset     : ${noiseHeight.toFixed(4)} m\n`;
            log += `  Restitution offset: ${noiseRest.toFixed(4)}\n`;
            log += `  Friction offset   : ${noiseFric.toFixed(4)}\n`;
            log += `  Adhesion offset   : ${noiseAdh.toFixed(4)}\n`;
            log += `  Altitude offset   : ${noiseAlt.toFixed(2)} km\n`;
            log += `  Time offset       : ${noiseTime.toFixed(3)} s\n`;
            log += '================================================\n';
            log += `\nInitial geometric top face : ${INITIAL_TOP_FACE}\n`;
            log += `Initial label on top       : ${faceLabels[INITIAL_TOP_FACE]}\n`;
            log += `Initial label on bottom    : ${faceLabels[(INITIAL_TOP_FACE + 2) % 4]}\n`;
            log += `\nDrop height (center)       : ${height.toFixed(4)} m\n`;
			log += `Unified_Math.PI            : ${Unified_Math.pii()}°\n`;
            log += `Base angle                 : ${(baseAngle).toFixed(2)}°\n`;
            log += `Initial angle              : ${(initAngle*180/Unified_Math.pii()).toFixed(2)}°\n`;
            log += `Initial spin (Omega)       : ${initOmega.toFixed(3)} rad/s\n`;
            log += `\nDice material              : ${DICE_MAT}\n`;
            log += `Surface material           : ${SURF_MAT}\n`;
            log += `Temperature                : ${TEMP.toFixed(1)} °C\n`;
            log += `Humidity                   : ${HUMID.toFixed(1)} %\n`;
            log += `Altitude                   : ${ALTITUDE.toFixed(0)} km\n`;
            log += `Gravity (g)                : ${G.toFixed(4)} m/s²\n`;
            log += `Simulation time (requested): ${SIM_TIME.toFixed(1)} s\n`;
            log += `Simulation time (effective): ${MAX_TIME.toFixed(2)} s\n`;
            log += `Effective restitution      : ${rest.toFixed(3)}\n`;
            log += `Effective friction         : ${fric.toFixed(3)}\n`;
            log += `Effective adhesion         : ${adh.toFixed(3)}\n`;
            log += '================================================\n';
            log += `JS_titles:      Time,      X,      Y,   Theta,     Vx,      Vy,    Omega\n`;

            // Physics loop
			// ==============================================================================
			// UNIFIED ADAPTIVE KINEMATIC INTEGRATION ENGINE LOOP (STRICT ATOMIC WORKSPACE)
			// ==============================================================================
			/*
			const DT_ZOOM_IN_SLOW = Unified_Math.val(0.0005);
			const DT_ZOOM_IN_FAST = Unified_Math.val(0.0007);
			const DT_ZOOM_OUT     = Unified_Math.val(0.001);
			const RD_TO_IMPACT    = Unified_Math.val(0.07);				// 7 cm
			const RT_TO_STOP      = Unified_Math.val(1.25);
			*/
			
            history = [];
            let t = Unified_Math.val(0.0);
            let settled = 0;
            let Look_Kinetic_Step = 1;
            
            // Map the initial starting array explicitly down to the active profile's parameters
            state = state.map(v => Unified_Math.val(v));

            while (Unified_Math.val(t) < Unified_Math.val(MAX_TIME)) {
                // ------------------------------------------------------------
                // 1. STEP SIZE SELECTION (EVALUATED BEFORE CORE KINEMATICS)
                // ------------------------------------------------------------
				// Force the boolean flags to compare strictly truncated 32-bit float spaces
				let remainingSim = Unified_Math.f32(Unified_Math.f32(MAX_TIME) - Unified_Math.f32(RT_TO_STOP));
				let zoomin_by_time = (Unified_Math.f32(t) >= Unified_Math.f32(remainingSim));
				let zoomin_by_dist = (Unified_Math.f32(state[1]) <= Unified_Math.f32(RD_TO_IMPACT));

                let activeDT;
                if (zoomin_by_time && zoomin_by_dist) {
                    activeDT = DT_ZOOM_IN_SLOW;
	                log += `JS_zoom_TD: `;
                } else if (zoomin_by_time) {
                    activeDT = DT_ZOOM_IN_FAST;
                    log += `JS_zoom_TX: `;
                } else if (zoomin_by_dist) {
                    activeDT = DT_ZOOM_IN_SLOW;
                    log += `JS_zoom_XD: `;
                } else {
                    activeDT = DT_ZOOM_OUT;
                }
                activeDT = Unified_Math.val(activeDT);

                // ------------------------------------------------------------
                // 2. KINEMATIC STEP INTEGRATIONS (ADAPTIVE ALU OPERATORS FORCED)
                // ------------------------------------------------------------
                
                // Pass A: Apply Gravitational Pull directly to Vertical Velocity: vy = vy - (G * dt)
                {
                    let gravityStepDelta = Unified_Math.mul(G, activeDT);
                    state[4] = Unified_Math.sub(state[4], gravityStepDelta);
                }
                
                // Pass B: Integrate Horizontal Position: x = x + (vx * dt)
                {
                    let positionStepDeltaX = Unified_Math.mul(state[3], activeDT);
                    state[0] = Unified_Math.add(state[0], positionStepDeltaX);
                }
                
                // Pass C: Integrate Vertical Position: y = y + (vy * dt)
                {
                    let positionStepDeltaY = Unified_Math.mul(state[4], activeDT);
                    state[1] = Unified_Math.add(state[1], positionStepDeltaY);
                }
                
                // Pass D: Integrate Angular Orientation: th = th + (om * dt)
                {
                    let angularStepDeltaTheta = Unified_Math.mul(state[5], activeDT);
                    state[2] = Unified_Math.add(state[2], angularStepDeltaTheta);
                }

                // ------------------------------------------------------------
                // 3. EVALUATE CONDITIONAL COLLISION LAYER DETECTIONS
                // ------------------------------------------------------------
                if (activeDT !== DT_ZOOM_OUT) {

					state[0] = Unified_Math.val(state[0]);   // x
					state[1] = Unified_Math.val(state[1]);	// y
					state[2] = Unified_Math.val(state[2]);	// th
					state[3] = Unified_Math.val(state[3]);	// vx
					state[4] = Unified_Math.val(state[4]);	// vy
					state[5] = Unified_Math.val(state[5]);	// om

                    log += `${t.toFixed(5)},${state[0].toFixed(5)},${state[1].toFixed(5)},${state[2].toFixed(5)},${state[3].toFixed(5)},${state[4].toFixed(5)},${state[5].toFixed(5)}\n`;
                    let [resState, collided] = collideAndResolve(state, rest, fric, adh, MASS, I, HALF);

                    if (state[5] != Unified_Math.val(resState[5]))
					{
						state[0] = Unified_Math.val(resState[0]);   // x
						state[1] = Unified_Math.val(resState[1]);	// y
						state[2] = Unified_Math.val(resState[2]);	// th
						state[3] = Unified_Math.val(resState[3]);	// vx
						state[4] = Unified_Math.val(resState[4]);	// vy
						state[5] = Unified_Math.val(resState[5]);	// om
	
			            //log += `JS_titles:      Time,      X,      Y,   Theta,     Vx,      Vy,    Omega\n`;
						log += `JS_impact+: ${t.toFixed(5)},${state[0].toFixed(5)},${state[1].toFixed(5)},${state[2].toFixed(5)},${state[3].toFixed(5)},${state[4].toFixed(5)},${state[5].toFixed(5)}\n`;
					}

                } else {
                    if (ACTIVE_SIMULATOR_PROFILE === "IEEE_754_32BIT") {
						state[0] = Unified_Math.val(state[0]);   // x
						state[1] = Unified_Math.val(state[1]);	// y
						state[2] = Unified_Math.val(state[2]);	// th
						state[3] = Unified_Math.val(state[3]);	// vx
						state[4] = Unified_Math.val(state[4]);	// vy
						state[5] = Unified_Math.val(state[5]);	// om
                    }
                }

                // Push a clean representation for historical drawing rendering paths
                history.push(Array.from(state));
                
                // ------------------------------------------------------------
                // 4. KINETIC ENERGY & SPEED CALCULATION ATOMIC WORKSPACE
                // ------------------------------------------------------------
                let vx_sq      = Unified_Math.mul(state[3], state[3]);
                let vy_sq      = Unified_Math.mul(state[4], state[4]);
                let linear_vel = Unified_Math.sqrt(Unified_Math.add(vx_sq, vy_sq));
                let angular_v  = Unified_Math.abs(state[5]);
                let rot_speed  = Unified_Math.mul(angular_v, SIDE);
                let speed      = Unified_Math.add(linear_vel, rot_speed);
                let groundBoundary = Unified_Math.add(HALF, Unified_Math.val(0.0005));
                
                // ============================================================
                // UPGRADED V1.2 HYBRID SLEEP OUT CHECK (ATOMIC RESTRUCTURE)
                // ============================================================
                if (state[1] < Unified_Math.val(0.05)) {
                    if (speed < Unified_Math.val(0.075)) {
			            log += `JS_trigger: [sleep_out] / [speed] ${speed.toFixed(5)} < 0.075 / [Y] ${state[1].toFixed(5)} < 0.05\n`;
			            log += `JS_titles:      Time,      X,      Y,   Theta,     Vx,      Vy,    Omega\n`;
						log += `JS_sleep_out: ${t.toFixed(5)},${state[0].toFixed(5)},${state[1].toFixed(5)},${state[2].toFixed(5)},${state[3].toFixed(5)},${state[4].toFixed(5)},${state[5].toFixed(5)}\n`;
                        break;
                    }
                }

                // ============================================================
                // Settlement Criteria Evaluation Check (Standard Mode Fallback)
                // ============================================================
                if (state[1] < groundBoundary && speed < Unified_Math.val(0.2)) {
                    settled++;
		            log += `JS_trigger: [settled ${settled} < 100] / [speed] ${speed.toFixed(5)} < 0.2 / [Y] ${state[1].toFixed(5)} < ${groundBoundary.toFixed(5)}\n`;
                    if (settled > 100) 
					{
			            log += `JS_titles:      Time,      X,      Y,   Theta,     Vx,      Vy,    Omega\n`;
						log += `JS_settled: ${t.toFixed(5)},${state[0].toFixed(5)},${state[1].toFixed(5)},${state[2].toFixed(5)},${state[3].toFixed(5)},${state[4].toFixed(5)},${state[5].toFixed(5)}\n`;
						break; 
					}
                } else {
                    settled = 0;
                }

                // ------------------------------------------------------------
                // 5. DIAGNOSTIC PRINTING TIMELINE ADVANCEMENT
                // ------------------------------------------------------------
                if (Look_Kinetic_Step == 1 && activeDT == DT_ZOOM_OUT) {
	                log += `JS_zoom_out: ${t.toFixed(5)},${state[0].toFixed(5)},${state[1].toFixed(5)},${state[2].toFixed(5)},${state[3].toFixed(5)},${state[4].toFixed(5)},${state[5].toFixed(5)}\n`;
                }
                
                Look_Kinetic_Step++;
                if (Look_Kinetic_Step == 51) {
                    Look_Kinetic_Step = 1;
                }

                // Step time variable natively using the atomic operator router
                t = Unified_Math.f32(Unified_Math.add(t, activeDT));
            }

            if (Unified_Math.val(t) >= Unified_Math.val(MAX_TIME))
			{
				log += `JS_titles:      Time,      X,      Y,   Theta,     Vx,      Vy,    Omega\n`;
				log += `JS_time_out: ${t.toFixed(5)},${state[0].toFixed(5)},${state[1].toFixed(5)},${state[2].toFixed(5)},${state[3].toFixed(5)},${state[4].toFixed(5)},${state[5].toFixed(5)}\n`;
			}

            // ==============================================================================
            // POST-PROCESSOR RESULT EXTRACTION TERMINAL WINDOW
            // ==============================================================================
			const finalTheta = Unified_Math.val(state[2]);
			const finalTopG  = faceFromAngle(finalTheta, 'top');
			const finalBotG  = faceFromAngle(finalTheta, 'bottom');
			finalTopLab      = faceLabels[finalTopG]; 
			const finalBotLab = faceLabels[finalBotG];

            // Replicate BASCOM's modulo angle check formatting precisely for logs
            const twoPi = Unified_Math.val(2 * Unified_Math.pii());
            let displayAngle = Unified_Math.val(finalTheta % twoPi);
            displayAngle = Unified_Math.val(displayAngle + twoPi);
            displayAngle = Unified_Math.val(displayAngle % twoPi);
            let displayDeg = Unified_Math.val(Unified_Math.val(displayAngle * 180) / Unified_Math.val(Unified_Math.pii()));

            log += '\n================================================\n';
            log += 'RESULT\n';
            log += '================================================\n';
            log += `Simulation time            : ${t.toFixed(2)} s\n`;
			log += `Final theta (radians)      : ${state[2]}\n`;
            log += `Final geometric top face   : ${finalTopG}\n`;
            log += `Final label on top         : ${finalTopLab}\n`;
            log += `Final label on bottom      : ${finalBotLab}\n`;
            log += `Final angle                : ${displayDeg.toFixed(1)}°\n`;
            log += '================================================\n';
            log += `>>>  TOP FACE SHOWS: ${finalTopLab}  <<<\n`;
            log += '================================================\n';
            logEl.textContent = log;

            computeView(history, HALF);
            replayBtn.disabled = false;

            if (SHOW_ANIM) playAnimation();
            else drawFrame(history.length - 1);
        }

		// Lightweight version used only in Stream mode
		// Returns only the final top label – no log, no history, no drawing
		function dropDiceSilent() {

    		// set simulator profile
			ACTIVE_SIMULATOR_PROFILE = "WEB_JS_64BIT";
			// Capture timer
			dropTimerMs = currentTimerMs;
			seedFrozen = true;
            //seedBox.value = noisyFactor(dropTimerMs).toFixed(6);
            seedBox.value = dropTimerMs;
		
			const HEIGHT = parseFloat(document.getElementById('height').value);
			const INITIAL_TOP_FACE = parseInt(document.getElementById('initTop').value) || 0;
			const INIT_OMEGA = parseFloat(document.getElementById('initOmega').value);
			const DICE_MAT = document.getElementById('diceMat').value;
			const SURF_MAT = document.getElementById('surfMat').value;
			const TEMP = parseFloat(document.getElementById('temperature').value) || 22;
			const HUMID = parseFloat(document.getElementById('humidity').value) || 45;
			const ALTITUDE = parseFloat(document.getElementById('altitude').value) || 0;
			const SIM_TIME = parseFloat(document.getElementById('simTime').value) || 12;
			const LABEL_MODE = document.getElementById('labelMode').value;
		
			// Core physical dimensions & system constraints
			const SIDE = 0.05;
			const MASS = 0.02;
			const DT = 0.0005;
			const HALF = SIDE / 2;
			const I    = 0.000008333;          // ← exact Bascom constant
		
			const NOISE_ANGLE  = 1.5 * Math.PI / 180;
			const NOISE_OMEGA  = 0.8;
			const NOISE_HEIGHT = 0.01;
			const NOISE_REST   = 0.02;
			const NOISE_FRIC   = 0.03;
			const NOISE_ADH    = 0.015;
			const NOISE_ALT    = 25;
			const NOISE_TIME   = 1.0;
		
			// Generate noises (same as normal path)
			const noiseAngle  = nRandRange(-NOISE_ANGLE,  NOISE_ANGLE);
			const noiseOmega  = nRandRange(-NOISE_OMEGA,  NOISE_OMEGA);
			const noiseHeight = nRandRange(-NOISE_HEIGHT, NOISE_HEIGHT);
			const noiseRest   = nRandRange(-NOISE_REST,   NOISE_REST);
			const noiseFric   = nRandRange(-NOISE_FRIC,   NOISE_FRIC);
			const noiseAdh    = nRandRange(-NOISE_ADH,    NOISE_ADH);
			const noiseAlt    = nRandRange(-NOISE_ALT,    NOISE_ALT);
			const noiseTime   = nRandRange(-NOISE_TIME,   NOISE_TIME);
						
			// Pool of labels
			let pool;
			if (LABEL_MODE === 'bin') {
				pool = [0, 1, 0, 1];
			} else if (LABEL_MODE === 'hex') {
				pool = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'];
			} else {
				pool = [1, 2, 3, 4, 5, 6];
			}

			// Co: Select labels
			// Proper unbiased sampling of 4 items without replacement
			const faceLabelsLocal = [];
			const temp = [...pool];
			
			for (let i = 0; i < 4; i++) {
				const j = nRandInt(0, temp.length - 1);
				faceLabelsLocal.push(temp[j]);
				temp.splice(j, 1); // remove selected item
			}

			const G = gravityAtAltitude(ALTITUDE + noiseAlt);
			const MAX_TIME = Math.max(3, SIM_TIME + noiseTime);
		
			// Materials
			const [bfd, brd, bad] = DICE_MATERIALS[DICE_MAT];
			const [bfs, brs, bas] = SURFACE_MATERIALS[SURF_MAT];

			const tempFactor  = 1.0 - (TEMP - 20) * 0.004;
			const humidFactor = 1.0 + (HUMID - 40) * 0.006;
		
			let baseRest = 0.5 * (brd + brs) * Math.max(0.6, tempFactor);
			let baseFric = 0.5 * (bfd + bfs) * Math.max(0.5, tempFactor) * Math.min(1.6, humidFactor);
			let baseAdh  = 0.5 * (bad + bas) * Math.min(2.0, humidFactor);
		
			const baseAngle = angleForTopFace(INITIAL_TOP_FACE);
			const initAngle = baseAngle + noiseAngle;
			const initOmega = INIT_OMEGA + noiseOmega;
			const height    = HEIGHT + noiseHeight;
		
			let rest = Math.max(0.05, Math.min(0.95, baseRest + noiseRest));
			let fric = Math.max(0.05, baseFric + noiseFric);
			let adh  = Math.max(0.0,  baseAdh  + noiseAdh);
		
			let state = [0, height, initAngle, 0, 0, initOmega];
		
			// Pure physics loop – no history, no drawing, no logging
			let t = 0, settled = 0;
			while (t < MAX_TIME) {

				// 1. STATE IDENTIFICATION GENERATION
				let remainingSim = MAX_TIME - RT_TO_STOP;
				let zoomin_by_time = (t >= remainingSim);
				let zoomin_by_dist = (state[1] <= RD_TO_IMPACT); // state[1] is center Y

				let activeDT;

				// 2. GEOMETRIC & DIRECTIONAL LIGHTWEIGHT SELECTION
				if (zoomin_by_time && zoomin_by_dist) {
					activeDT = DT_ZOOM_IN_SLOW;
				} else if (zoomin_by_time) {
					activeDT = DT_ZOOM_IN_FAST;
				} else if (zoomin_by_dist) {
					activeDT = DT_ZOOM_IN_SLOW;
				} else {
					activeDT = DT_ZOOM_OUT;
				}

				// Apply Gravitational Pull and Kinematic Position Integration using activeDT
				// 1. Gravity
				{
					let tmp = G * activeDT;
					state[4] = state[4] - tmp;
				}
				// 2. X
				{
					let tmp = state[3] * activeDT;
					state[0] = state[0] + tmp;
				}
				// 3. Y
				{
					let tmp = state[4] * activeDT;
					state[1] = state[1] + tmp;
				}
				// 4. Theta
				{
					let tmp = state[5] * activeDT;
					state[2] = state[2] + tmp;
				}
		
				// Evaluate structural collisions checks safely
				if (activeDT !== DT_ZOOM_OUT) {
					[state] = collideAndResolve(state, rest, fric, adh, MASS, I, HALF);
				}

				// speed calculation also forced to f32
				let speed = Math.hypot(state[3], state[4]) + Math.abs(state[5] * SIDE);

				//============================================================
				// UPGRADED V1.2 HYBRID SLEEP OUT CHECK
				//============================================================
				// If the die center Y drops under the 1mm floor boundary zone 
				// and total remaining energy drops below 0.05, put it to sleep!
				if (state[1] < 0.05) {
					if (speed < 0.075) {
						break;
					}
				}

				//============================================================
				// Settlement Criteria Evaluation Check (Standard Mode Fallback)
				//============================================================
				if (speed < 0.01 && state[1] < HALF + 0.01) {
					if (++settled > 100) break; // Synced with the 100 frame cap adjustment
				} else {
					settled = 0;
				}

				// Step simulation time counter forward dynamically
				t += activeDT;
			}
		
			const finalTopG = faceFromAngle(state[2], 'top');
			return faceLabelsLocal[finalTopG];   // ← only this is returned
		}

		// ---------- Events ----------
		let isGenerating = false;          // global lock
		
		dropBtn.addEventListener('click', async () => {
			if (isGenerating) return;
		
			const generateStream = document.getElementById('generateStream').value === 'true';
			const seqAmount = Math.max(1, parseInt(document.getElementById('sequenceAmount').value) || 1);
		
			if (!generateStream) {
				dropBtn.disabled = true;
				dropDice();                     // normal detailed version
				setTimeout(() => dropBtn.disabled = false, 300);
				return;
			}
		
			// ========== STREAM MODE (lightweight + configurable) ==========
			isGenerating = true;
			dropBtn.disabled = true;
			shuffleBtn.disabled = true;
			importBtn.disabled = true;
			exportBtn.disabled = true;
			replayBtn.disabled = true;
			
			const canvasContainer = document.getElementById('canvas-container');
			const generateStream_Canvas = document.getElementById('generateStream');
			if (generateStream_Canvas.value === 'true') {
				canvasContainer.style.display = 'none';          // hide when streaming
			} else {
				canvasContainer.style.display = 'block';         // show when normal mode
			}
	
			const results = [];
			const BATCH_SIZE   = Math.max(5,  parseInt(document.getElementById('batchSize').value)  || 10);
			const UPDATE_EVERY = Math.max(1,  parseInt(document.getElementById('updateEvery').value) || 4);
			
			logEl.textContent = `Generating stream of ${seqAmount.toLocaleString()} results…\n` +
								`Silent mode – no logs / no graphics\n` +
								`Batch size: ${BATCH_SIZE} | Update every: ${UPDATE_EVERY} batches\n\n` +
								`Progress: 0 / ${seqAmount.toLocaleString()} (0.0%)\n`;
			
			const yieldToBrowser = () => new Promise(r => setTimeout(r, 0));
			
			try {
				for (let i = 0; i < seqAmount; i++) {
					shuffleSettings();
					const label = dropDiceSilent();
					results.push(label);
			
					// Live progress update + chaotic counter reset
					if ((i + 1) % (BATCH_SIZE * UPDATE_EVERY) === 0 || i === seqAmount - 1) {
						// → Reset counter here for extra chaos
						//noisyCallCounter = 0;
			
						const pct = ((i + 1) / seqAmount * 100).toFixed(1);
						const preview = results.slice(-166).join('');
			
						logEl.textContent =
`Generating stream of ${seqAmount.toLocaleString()} results…
Silent mode | Batch: ${BATCH_SIZE} | Update every: ${UPDATE_EVERY} | Simulator profile: ${ACTIVE_SIMULATOR_PROFILE}
Random mode: ${randMode.value} | Noise mode: ${noiseMode.value} | TimerMs: ${currentTimerMs} | Counter: ${noisyCallCounter} 

Progress : ${(i + 1).toLocaleString()} / ${seqAmount.toLocaleString()}  (${pct}%)
Length   : ${results.length.toLocaleString()}

─── Latest part of the stream ───
${preview}
`;
						logEl.scrollTop = logEl.scrollHeight;
						await yieldToBrowser();
					}
			
					// Yield every batch to keep UI responsive
					if ((i + 1) % BATCH_SIZE === 0) {
						await yieldToBrowser();
					}
				}
			
				// Final result
				const finalStream = results.join('');
				logEl.textContent =
`================================================
STREAM GENERATED SUCCESSFULLY
================================================
Simulator profile: ${ACTIVE_SIMULATOR_PROFILE}
Sequence length  : ${seqAmount.toLocaleString()}
Label mode       : ${document.getElementById('labelMode').value}
Batch size       : ${BATCH_SIZE}
Update every     : ${UPDATE_EVERY}
Random mode      : ${randMode.value}
Noise mode       : ${noiseMode.value}
TimerMs          : ${currentTimerMs}
Counter          : ${noisyCallCounter} 
Characters       : ${finalStream.length.toLocaleString()}
================================================
${finalStream}
`;
				logEl.scrollTop = 0;
			
			} catch (err) {
				logEl.textContent += `\n\nERROR: ${err.message}`;
				console.error(err);
			} finally {
				isGenerating = false;
				dropBtn.disabled = false;
				shuffleBtn.disabled = false;
				importBtn.disabled = false;
				exportBtn.disabled = false;
			}

		});

		// Show / hide canvas depending on Generate Stream mode
		document.getElementById('generateStream').addEventListener('change', function () {
			const canvasContainer = document.getElementById('canvas-container');
			if (this.value === 'true') {
				canvasContainer.style.display = 'none';          // hide when streaming
			} else {
				canvasContainer.style.display = 'block';         // show when normal mode
			}
		});

        replayBtn.addEventListener('click', () => { if (history.length) playAnimation(); });
        shuffleBtn.addEventListener('click', shuffleSettings);
        exportBtn.addEventListener('click', exportConfig);
        importBtn.addEventListener('click', importConfig);
    </script>

    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>