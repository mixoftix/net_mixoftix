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


        // ---------- Classic helpers ----------
		function isShowAnim() {
			return document.getElementById('showAnim').value === 'true';
		}
		function isStreamMode() {
			return document.getElementById('generateStream').value === 'true';
		}		

        function angleForTopFace(topFace) {
            return (2 - topFace) * (Math.PI / 2);
        }
        function faceFromAngle(theta, which = 'top') {
            let th = ((theta % (2 * Math.PI)) + 2 * Math.PI) % (2 * Math.PI);
            let idx = Math.floor((th + Math.PI / 4) / (Math.PI / 2)) % 4;
            return which === 'bottom' ? idx : (idx + 2) % 4;
        }
        function vertices(x, y, theta, half) {
            const c = Math.cos(theta), s = Math.sin(theta);
            const local = [[-half,-half],[half,-half],[half,half],[-half,half]];
            return local.map(([lx, ly]) => [
                x + lx * c - ly * s,
                y + lx * s + ly * c
            ]);
        }
        function gravityAtAltitude(km) {
            const r = EARTH_RADIUS_KM + Math.max(0, km);
            return G0 * Math.pow(EARTH_RADIUS_KM / r, 2);
        }

        function collideAndResolve(st, restitution, friction, adhesion, mass, I, half) {
            let [x, y, th, vx, vy, om] = st;
            const verts = vertices(x, y, th, half);
            let minY = Infinity, idx = 0;
            for (let i = 0; i < 4; i++) {
                if (verts[i][1] < minY) { minY = verts[i][1]; idx = i; }
            }
            if (minY >= 0) return [st, false];

            const [px, py] = verts[idx];
            const r = [px - x, py - y];
            const vContact = [vx - om * r[1], vy + om * r[0]];
            const vn = vContact[1];

            const rnCross = r[0];
            const invMn = 1/mass + (rnCross * rnCross) / I;
            let jn = 0;
            if (vn < 0) jn = -(1 + restitution) * vn / invMn;
            if (Math.abs(vn) < 0.8) jn += -adhesion * 0.15 * mass;

            const vt = vContact[0];
            const rtCross = -r[1];
            const invMt = 1/mass + (rtCross * rtCross) / I;
            let jt = -vt / invMt;
            const maxF = friction * Math.abs(jn);
            jt = Math.max(-maxF, Math.min(maxF, jt));

            vx += jt / mass;
            vy += jn / mass;
            om += (r[0] * jn - r[1] * jt) / I;
            y -= minY + 1e-6;

            return [[x, y, th, vx, vy, om], true];
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
            const step = Math.max(8, Math.min(40, Math.floor(history.length / 180)));
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

                        // Restore UI
                        document.getElementById('labelMode').value   = cfg.labelMode || 'dice';
                        document.getElementById('diceMat').value     = cfg.diceMat || 'plastic';
                        document.getElementById('surfMat').value     = cfg.surfMat || 'wood';
                        document.getElementById('temperature').value = cfg.temperature ?? 22;
                        document.getElementById('humidity').value    = cfg.humidity ?? 45;
                        document.getElementById('altitude').value    = cfg.altitude ?? 0;
                        document.getElementById('height').value      = cfg.height ?? 2.1;
                        document.getElementById('initOmega').value   = cfg.initOmega ?? 3;
                        document.getElementById('initTop').value     = cfg.initTop ?? 0;
                        document.getElementById('simTime').value     = cfg.simTime ?? 12;
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

                        logEl.textContent = 'Exact session imported.\nClick “Drop the dice” to replay the identical simulation (same noises & labels).';

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

			// Capture timer & freeze seed box
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
			const SHOW_ANIM = isShowAnim();

            const SIDE = 0.05, MASS = 0.02, DT = 0.0005;
            const HALF = SIDE / 2;
            const I = MASS * SIDE * SIDE / 6;

            const NOISE_ANGLE  = 1.5 * Math.PI / 180;
            const NOISE_OMEGA  = 0.8;
            const NOISE_HEIGHT = 0.01;
            const NOISE_REST   = 0.02;
            const NOISE_FRIC   = 0.03;
            const NOISE_ADH    = 0.015;
            const NOISE_ALT    = 25;
            const NOISE_TIME   = 1.0;

            // ----- Exact replay or new generation -----
            let noiseAngle, noiseOmega, noiseHeight, noiseRest, noiseFric, noiseAdh, noiseAlt, noiseTime;

            if (useExactSession && lastSession) {
                noiseAngle  = lastSession.noiseAngle;
                noiseOmega  = lastSession.noiseOmega;
                noiseHeight = lastSession.noiseHeight;
                noiseRest   = lastSession.noiseRest;
                noiseFric   = lastSession.noiseFric;
                noiseAdh    = lastSession.noiseAdh;
                noiseAlt    = lastSession.noiseAlt;
                noiseTime   = lastSession.noiseTime;
                faceLabels  = [...lastSession.faceLabels];
                dropTimerMs = lastSession.dropTimerMs;
                //seedBox.value = noisyFactor(dropTimerMs).toFixed(6);
                seedBox.value = dropTimerMs;
            } else {
				noiseAngle  = nRandRange(-NOISE_ANGLE,  NOISE_ANGLE);
                noiseOmega  = nRandRange(-NOISE_OMEGA,  NOISE_OMEGA);
                noiseHeight = nRandRange(-NOISE_HEIGHT, NOISE_HEIGHT);
                noiseRest   = nRandRange(-NOISE_REST,   NOISE_REST);
                noiseFric   = nRandRange(-NOISE_FRIC,   NOISE_FRIC);
                noiseAdh    = nRandRange(-NOISE_ADH,    NOISE_ADH);
                noiseAlt    = nRandRange(-NOISE_ALT,    NOISE_ALT);
                noiseTime   = nRandRange(-NOISE_TIME,   NOISE_TIME);
				
                /*
				// Fill the case list
				let noiseCases = [1,2,3,4,5,6,7,8];
				
				// Loop until all cases are consumed
				while (noiseCases.length > 0) {
					// Pick a random index
					let idx = Math.floor(main_random() * noiseCases.length);
					let selected = noiseCases[idx];
				
					// Execute one noise update
					switch (selected) {
						case 1:
							noiseAngle  = nRandRange(-NOISE_ANGLE,  NOISE_ANGLE);
							break;
						case 2:
							noiseOmega  = nRandRange(-NOISE_OMEGA,  NOISE_OMEGA);
							break;
						case 3:
							noiseHeight = nRandRange(-NOISE_HEIGHT, NOISE_HEIGHT);
							break;
						case 4:
							noiseRest   = nRandRange(-NOISE_REST,   NOISE_REST);
							break;
						case 5:
							noiseFric   = nRandRange(-NOISE_FRIC,   NOISE_FRIC);
							break;
						case 6:
							noiseAdh    = nRandRange(-NOISE_ADH,    NOISE_ADH);
							break;
						case 7:
							noiseAlt    = nRandRange(-NOISE_ALT,    NOISE_ALT);
							break;
						case 8:
							noiseTime   = nRandRange(-NOISE_TIME,   NOISE_TIME);
							break;
					}
					// Remove the executed case
					noiseCases.splice(idx, 1);
				}
				*/


				// Pool of labels
				let pool;
				if (LABEL_MODE === 'bin') {
					pool = [0, 1, 0, 1];
				} else if (LABEL_MODE === 'hex') {
					pool = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'];
				} else {
					pool = [1, 2, 3, 4, 5, 6];
				}
	
				// Gr: Select labels
				/*
                for (let i = pool.length - 1; i > 0; i--) {
                    const j = nRandInt(0, i);
                    [pool[i], pool[j]] = [pool[j], pool[i]];
                }
                faceLabels = pool.slice(0, 4);
				*/
			
				// Co: Select labels
				// Proper unbiased sampling of 4 items without replacement
				const faceLabelsLocal = [];
				const temp = [...pool];
				
				for (let i = 0; i < 4; i++) {
					const j = nRandInt(0, temp.length - 1);
					faceLabelsLocal.push(temp[j]);
					temp.splice(j, 1); // remove selected item
				}

				faceLabels = faceLabelsLocal;
            }

            const G = gravityAtAltitude(ALTITUDE + noiseAlt);
            const MAX_TIME = Math.max(3, SIM_TIME + noiseTime);

            // Materials
            const [brd, bfd, bad] = DICE_MATERIALS[DICE_MAT];
            const [brs, bfs, bas] = SURFACE_MATERIALS[SURF_MAT];

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

            // Store exact session for future export / replay
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
				showAnim: isShowAnim()
            };
            useExactSession = false; // next normal drop will generate new values

            // ----- Log -----
            let log = '================================================\n';
            log += 'DICE DROP – INITIAL PARAMETERS\n';
            log += '================================================\n';
            log += `Label mode                 : ${LABEL_MODE}\n`;
            log += `Random mode                : ${randMode.value}\n`;
            log += `Noise mode                 : ${noiseMode.value}\n`;
            log += `Timer (ms) at drop         : ${dropTimerMs}\n`;
            log += `Counter at drop            : ${noisyCallCounter}\n`;
            log += `Noisy factor               : ${noisyFactor(dropTimerMs).toFixed(6)}\n`;
            log += 'Geometric faces --> Labels:\n';
            for (let i = 0; i < 4; i++) log += `  Face ${i}  -->  ${faceLabels[i]}\n`;
            log += `\nInitial geometric top face : ${INITIAL_TOP_FACE}\n`;
            log += `Initial label on top       : ${faceLabels[INITIAL_TOP_FACE]}\n`;
            log += `Initial label on bottom    : ${faceLabels[(INITIAL_TOP_FACE + 2) % 4]}\n`;
            log += `\nDrop height (center)       : ${height.toFixed(4)} m\n`;
            log += `Initial angle              : ${(initAngle*180/Math.PI).toFixed(2)}°\n`;
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
            log += `\nActual noise applied (timer-driven):\n`;
            log += `  Angle offset      : ${(noiseAngle*180/Math.PI).toFixed(3)}°\n`;
            log += `  Spin offset       : ${noiseOmega.toFixed(3)} rad/s\n`;
            log += `  Height offset     : ${noiseHeight.toFixed(4)} m\n`;
            log += `  Restitution offset: ${noiseRest.toFixed(4)}\n`;
            log += `  Friction offset   : ${noiseFric.toFixed(4)}\n`;
            log += `  Adhesion offset   : ${noiseAdh.toFixed(4)}\n`;
            log += `  Altitude offset   : ${noiseAlt.toFixed(2)} km\n`;
            log += `  Time offset       : ${noiseTime.toFixed(3)} s\n`;
            log += '================================================\n';

            // Physics loop
            history = [];
            let t = 0, settled = 0;
            while (t < MAX_TIME) {
                state[4] -= G * DT;
                state[0] += state[3] * DT;
                state[1] += state[4] * DT;
                state[2] += state[5] * DT;

                [state] = collideAndResolve(state, rest, fric, adh, MASS, I, HALF);
                history.push([...state]);

                const speed = Math.hypot(state[3], state[4]) + Math.abs(state[5]) * SIDE;
                if (speed < 0.01 && state[1] < HALF + 0.01) {
                    if (++settled > 200) break;
                } else settled = 0;
                t += DT;
            }

            const finalTheta = state[2];
            const finalTopG  = faceFromAngle(finalTheta, 'top');
            const finalBotG  = faceFromAngle(finalTheta, 'bottom');
            finalTopLab = faceLabels[finalTopG];
            const finalBotLab = faceLabels[finalBotG];

            log += '\n================================================\n';
            log += 'RESULT\n';
            log += '================================================\n';
            log += `Simulation time            : ${t.toFixed(2)} s\n`;
            log += `Final geometric top face   : ${finalTopG}\n`;
            log += `Final label on top         : ${finalTopLab}\n`;
            log += `Final label on bottom      : ${finalBotLab}\n`;
            log += `Final angle                : ${(((finalTheta%(2*Math.PI))+2*Math.PI)%(2*Math.PI)*180/Math.PI).toFixed(1)}°\n`;
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
		
			const SIDE = 0.05, MASS = 0.02, DT = 0.0005;
			const HALF = SIDE / 2;
			const I = MASS * SIDE * SIDE / 6;
		
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
						
			/*
			// Define all noise variables
			let noiseAngle, noiseOmega, noiseHeight, noiseRest;
			let noiseFric, noiseAdh, noiseAlt, noiseTime;
			
			// Fill the case list
			let noiseCases = [1,2,3,4,5,6,7,8];
			
			// Loop until all cases are consumed
			while (noiseCases.length > 0) {
				// Pick a random index
				let idx = Math.floor(main_random() * noiseCases.length);
				let selected = noiseCases[idx];
			
				// Execute one noise update
				switch (selected) {
					case 1:
						noiseAngle  = nRandRange(-NOISE_ANGLE,  NOISE_ANGLE);
						break;
					case 2:
						noiseOmega  = nRandRange(-NOISE_OMEGA,  NOISE_OMEGA);
						break;
					case 3:
						noiseHeight = nRandRange(-NOISE_HEIGHT, NOISE_HEIGHT);
						break;
					case 4:
						noiseRest   = nRandRange(-NOISE_REST,   NOISE_REST);
						break;
					case 5:
						noiseFric   = nRandRange(-NOISE_FRIC,   NOISE_FRIC);
						break;
					case 6:
						noiseAdh    = nRandRange(-NOISE_ADH,    NOISE_ADH);
						break;
					case 7:
						noiseAlt    = nRandRange(-NOISE_ALT,    NOISE_ALT);
						break;
					case 8:
						noiseTime   = nRandRange(-NOISE_TIME,   NOISE_TIME);
						break;
				}
				// Remove the executed case
				noiseCases.splice(idx, 1);
			}
			*/

			// Pool of labels
			let pool;
			if (LABEL_MODE === 'bin') {
				pool = [0, 1, 0, 1];
			} else if (LABEL_MODE === 'hex') {
				pool = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'];
			} else {
				pool = [1, 2, 3, 4, 5, 6];
			}

			// Gr: Select labels
			/*
			for (let i = pool.length - 1; i > 0; i--) {
				const j = nRandInt(0, i);
				[pool[i], pool[j]] = [pool[j], pool[i]];
			}
			const faceLabelsLocal = pool.slice(0, 4);
			*/
		
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
			const [brd, bfd, bad] = DICE_MATERIALS[DICE_MAT];
			const [brs, bfs, bas] = SURFACE_MATERIALS[SURF_MAT];
		
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
				state[4] -= G * DT;
				state[0] += state[3] * DT;
				state[1] += state[4] * DT;
				state[2] += state[5] * DT;
		
				[state] = collideAndResolve(state, rest, fric, adh, MASS, I, HALF);
		
				const speed = Math.hypot(state[3], state[4]) + Math.abs(state[5]) * SIDE;
				if (speed < 0.01 && state[1] < HALF + 0.01) {
					if (++settled > 200) break;
				} else {
					settled = 0;
				}
				t += DT;
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
Silent mode | Batch: ${BATCH_SIZE} | Update every: ${UPDATE_EVERY}
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
Sequence length : ${seqAmount.toLocaleString()}
Label mode      : ${document.getElementById('labelMode').value}
Batch size      : ${BATCH_SIZE}
Update every    : ${UPDATE_EVERY}
Random mode     : ${randMode.value}
Noise mode      : ${noiseMode.value}
TimerMs         : ${currentTimerMs}
Counter         : ${noisyCallCounter} 
Characters      : ${finalStream.length.toLocaleString()}
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