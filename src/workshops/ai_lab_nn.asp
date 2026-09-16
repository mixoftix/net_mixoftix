<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
 <meta charset="UTF-8">
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
 <title>Neural Network Lab</title>
 <meta name="description" content="Browser-based multi-layer neural network trainer with live visualization, configurable activations, mini-batch SGD, adaptive learning rate, and dataset-only training.">
 <meta name="author" content="shahiN Noursalehi">

 <!--#INCLUDE virtual="/inc_styles.asp"-->

 <style>
 body {
 transition: background-color 0.15s, color 0.15s;
 }
 .controls {
 display: grid;
 grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
 gap: 12px;
 margin-bottom: 18px;
 }
 label {
 display: block;
 font-size: 13px;
 margin-bottom: 4px;
 font-weight: 600;
 }
 input, select, button, textarea {
 width: 100%;
 padding: 8px 10px;
 border: 1px solid #ccc;
 border-radius: 6px;
 font-size: 14px;
 line-height: 1.3;
 box-sizing: border-box;
 }
 input[type="number"], select, button {
 height: 38px;
 }
 input[type="checkbox"],
 input[type="radio"] {
 width: auto;
 height: auto;
 padding: 0;
 border: none;
 border-radius: 0;
 margin-right: 6px;
 vertical-align: middle;
 }
 textarea {
 height: 120px;
 font-family: ui-monospace, 'Courier New', monospace;
 resize: vertical;
 }
 button {
 background: #2563eb;
 color: white;
 border: none;
 cursor: pointer;
 font-weight: 600;
 }
 button:hover { background: #1d4ed8; }
 button:disabled { background: #94a3b8; cursor: not-allowed; }
 button.secondary {
 background: #0f766e;
 }
 button.secondary:hover { background: #0d9488; }
 button.danger {
 background: #dc2626;
 }
 button.danger:hover { background: #b91c1c; }
 button.export {
 background: #7c3aed;
 }
 button.export:hover { background: #6d28d9; }

 .checkbox-row, .radio-row {
 display: flex;
 align-items: center;
 gap: 6px;
 margin-top: 4px;
 font-size: 13px;
 font-weight: 500;
 }

 #vizStack {
 display: flex;
 flex-direction: column;
 gap: 8px;
 margin-top: 16px;
 }
 #bottomRow {
 display: flex;
 gap: 20px;
 flex-wrap: wrap;
 }
 #bottomRow > div {
 flex: 1;
 min-width: 300px;
 }

	svg {
		width: 100%;
		height: 480px;
		border: 1px solid #cbd5e1;
		border-radius: 8px;
		background: #ffffff;
	}
	body.dark-mode svg {
		background: #0f172a;
		border-color: #334155;
	}
	#lossGraph {
		height: 180px;
	}

 pre, #log, #nnDef, #testResults {
 font-family: ui-monospace, 'Courier New', monospace;
 font-size: 13px;
 padding: 16px;
 border-radius: 8px;
 white-space: pre-wrap;
 max-height: 380px;
 overflow-y: auto;
 background: #1e293b;
 color: #e2e8f0;
 margin: 0 0 16px 0;
 }
 body:not(.dark-mode) pre,
 body:not(.dark-mode) #log,
 body:not(.dark-mode) #nnDef,
 body:not(.dark-mode) #testResults {
 background: #f1f5f9;
 color: #1e293b;
 border: 1px solid #cbd5e1;
 }

 .section-title {
 margin-top: 20px;
 margin-bottom: 8px;
 font-size: 1.15rem;
 }
 .full-width {
 grid-column: 1 / -1;
 }
 </style>
</head>
<body class="dark-mode">
 <header>
 <h1>Neural Network Lab</h1>
 <p>by shahiN Noursalehi</p>
 <label>
 <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()" style="font-family: 'Courier New', monospace;padding: 4px;margin-right: 4px;"> Dark Mode
 </label>
 </header>

 <!-- Navigation Bar -->
 <section class="content-box">
 You are here: 
 <a href="/">Home</a> /
 Workshops /
 <a href="/workshops/ai_lab_nn.asp">Neural Network Lab</a>
 </section>

 <!-- Main Content -->
 <main>
 <!-- Introduction -->
 <section class="content-box">
 <h2>Dataset-Driven Multi-Layer Neural Network Trainer</h2>
 <p>
 Train a fully-connected multi-layer neural network directly from complete input-output patterns.
 Configure hidden layers, activations (ReLU, LeakyReLU, Sigmoid, tanh, Linear, Softmax),
 initialization schemes, mini-batch SGD, adaptive learning-rate on validation plateau,
 and live SVG visualization of weights, biases and activations.
 </p>
 </section>

 <!-- Simulator -->
 <section class="content-box">
 <h2>Simulator</h2>

 <div class="controls">
    <!-- Pair 0 -->
	<div>
		<label>&nbsp;</label>
		<button id="defaultBtn" class="secondary">Default Network</button>
	</div>
	<div>
		<label>&nbsp;</label>
		<button id="importBtn" class="export">Import Network</button>
	</div>

 <!-- Pair 1 -->
 <div>
 <label>Input Neurons (UI hint)</label>
 <input id="inp" type="number" value="4" min="1">
 </div>
 <div>
 <label>Output Neurons (UI hint)</label>
 <input id="out" type="number" value="3" min="1">
 </div>

 <!-- Pair 2 -->
 <div class="full-width">
 <label>Hidden Neurons (comma separated)</label>
 <input id="hid" type="text" value="4">
 </div>

 <!-- Pair 3 -->
 <div>
 <label>Hidden Activation</label>
 <select id="hiddenAct">
 <option value="relu">ReLU</option>
 <option value="leaky">LeakyReLU</option>
 <option value="sigmoid">Sigmoid</option>
 <option value="tanh">tanh</option>
 <option value="linear">Linear</option>
 </select>
 </div>
 <div>
 <label>Output Activation</label>
 <select id="outputAct">
 <option value="relu">ReLU</option>
 <option value="leaky">LeakyReLU</option>
 <option value="sigmoid">Sigmoid</option>
 <option value="tanh">tanh</option>
 <option value="softmax">Softmax</option>
 <option value="linear">Linear</option>
 </select>
 </div>

 <!-- Pair 4 -->
 <div>
 <label>Learning Rate</label>
 <input id="lr" type="number" value="0.01" step="0.001">
 </div>
 <div>
 <label>Stop Loss Value</label>
 <input id="stopLoss" type="number" value="0.001" step="0.0001">
 </div>

 <!-- Pair 5 -->
 <div>
 <label>Training Steps</label>
 <input id="steps" type="number" value="5000" min="1">
 </div>
 <div>
 <label>Log Interval (steps)</label>
 <input id="logInterval" type="number" value="100" min="1">
 </div>

 <!-- Pair 6 -->
 <div>
 <label>Evaluation Percent (0-100)</label>
 <input id="evalPercent" type="number" value="20" min="0" max="100">
 </div>
 <div>
 <label>Batch Size (1 = online)</label>
 <input id="batchSize" type="number" value="16" min="1">
 </div>

 <!-- Pair 7 -->
 <div>
 <label>Patience (plateau steps)</label>
 <input id="patience" type="number" value="200" min="1">
 </div>
 <div>
 <label>LR Multiplier (on plateau)</label>
 <input id="lrMultiplier" type="number" value="0.5" step="0.01" min="0.01" max="1">
 </div>

 <!-- Initialization radios + remaining checkboxes -->
	<div class="full-width">
		<div class="radio-row">
			<input type="radio" name="initScheme" id="initNegOneToOne" value="negOneToOne" checked>
			<span>Use -1 to 1 initialization</span>
		</div>
		<div class="radio-row">
			<input type="radio" name="initScheme" id="initZeroToOne" value="zeroToOne">
			<span>Use 0 to 1 initialization</span>
		</div>
		<div class="radio-row">
			<input type="radio" name="initScheme" id="initZeroOrOne" value="zeroOrOne">
			<span>Use 0 or 1 initialization</span>
		</div>
		<div class="radio-row">
			<input type="radio" name="initScheme" id="initXavier" value="xavier">
			<span>Use Xavier initialization</span>
		</div>
		<div class="radio-row">
			<input type="radio" name="initScheme" id="initGeneral" value="minmax">
			<span>Use MinMax initialization</span>
		</div>
	
		<div class="checkbox-row" style="margin-top:12px;">
			<input id="trainBiases" type="checkbox" checked>
			<span>Train Biases</span>
		</div>
		<div class="checkbox-row">
			<input id="shuffleData" type="checkbox">
			<span>Shuffle dataset before splitting</span>
		</div>
		<div class="checkbox-row">
			<input id="useCrossEntropy" type="checkbox">
			<span>Use Cross-Entropy loss for softmax</span>
		</div>
	</div>
				
 <!-- Dataset -->
 <div class="full-width">
 <label>Complete Patterns (newline separated — inputs + outputs)</label>
 <textarea id="completePatterns" placeholder="e.g.&#10;5.1,3.5,1.4,0.2,1,0,0&#10;7.0,3.2,4.7,1.4,0,1,0"></textarea>
 </div>

 <!-- Buttons: Begin / Stop -->
 <div>
 <button id="startBtn">Begin Simulation</button>
 </div>
 <div>
 <button id="stopBtn" class="danger">Stop</button>
 </div>

 <!-- Buttons: Reset / Export -->
 <div>
 <button id="resetBtn" class="secondary">Reset Network</button>
 </div>
 <div>
 <button id="exportBtn" class="export">Export Network</button>
 </div>

 </div>

 <!-- Visualization stack (wider) -->
 <div id="vizStack">
 <div>
 <h3 class="section-title">Network Visualization</h3>
 <svg id="nnViz" viewBox="0 0 1000 480" preserveAspectRatio="xMidYMid meet"></svg>
 </div>

 <div>
 <h3 class="section-title">Training Loss</h3>
 <svg id="lossGraph" viewBox="0 0 1000 180" preserveAspectRatio="none"></svg>
 </div>

 <div>
 <h3 class="section-title">Training Log</h3>
 <pre id="log">Ready. Paste patterns and click “Begin Simulation”.</pre>
 </div>

 <div id="bottomRow">
 <div>
 <h3 class="section-title">Machine-Readable NN Definition</h3>
 <pre id="nnDef"></pre>
 </div>
 <div>
 <h3 class="section-title">Evaluation Results</h3>
 <pre id="testResults"></pre>
 </div>
 </div>
 </div>
 </section>

 <!-- Acknowledgments -->
 <section class="content-box">
 <h3>Acknowledgments</h3>
 <p>Special thanks to Grok for its invaluable assistance in creating this neural network simulator for the <strong>Deep Inside</strong> workshop series.</p>
 </section>
 </main>

 <script>
 // ---------- Dark mode toggle ----------
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

 /* -------------------- Utilities -------------------- */
 function rand() { return (Math.random() * 2 - 1); }
 function zeros(n) { return Array.from({ length: n }, () => 0); }
 function sigmoid(x) { return 1 / (1 + Math.exp(-x)); }
 function dsigmoid(y) { return y * (1 - y); }
 function tanh_deriv(y) { return 1 - y * y; }
 function act_fn(name, x) {
 switch (name) {
 case "relu": return Math.max(0, x);
 case "leaky": return x > 0 ? x : 0.01 * x;
 case "tanh": return Math.tanh(x);
 case "linear": return x;
 default: return sigmoid(x);
 }
 }
 function act_deriv(name, y) {
 switch (name) {
 case "relu": return y > 0 ? 1 : 0;
 case "leaky": return y > 0 ? 1 : 0.01;
 case "tanh": return tanh_deriv(y);
 case "linear": return 1;
 default: return dsigmoid(y);
 }
 }
 function softmax(arr) {
 let max = Math.max(...arr);
 let exps = arr.map(v => Math.exp(v - max));
 let s = exps.reduce((a, b) => a + b, 0);
 return exps.map(v => v / s);
 }
 function shuffleInPlace(a, b) {
 for (let i = a.length - 1; i > 0; i--) {
 let j = Math.floor(Math.random() * (i + 1));
 [a[i], a[j]] = [a[j], a[i]];
 [b[i], b[j]] = [b[j], b[i]];
 }
 }

 function getSelectedInitScheme() {
 const radios = document.getElementsByName("initScheme");
 for (const r of radios) {
 if (r.checked) return r.value;
 }
 return "general";
 }

 /* -------------------- Dataset parsing -------------------- */
 // Now uses Output Neurons (UI hint) as the number of trailing output values
 function parseCompleteDataset(text, outputItems) {
 const lines = text.split("\n").map(l => l.trim()).filter(l => l.length > 0);
 const inputs = [], outputs = [];
 for (let line of lines) {
 const parts = line.split(",").map(s => s.trim());
 if (parts.length <= outputItems) continue;
 const inParts = parts.slice(0, parts.length - outputItems);
 const outParts = parts.slice(parts.length - outputItems);
 const inVals = inParts.map(v => { const n = Number(v); return isNaN(n) ? v : n; });
 const outVals = outParts.map(v => { const n = Number(v); return isNaN(n) ? v : n; });
 inputs.push(inVals);
 outputs.push(outVals);
 }
 return { inputs, outputs };
 }

 /* -------------------- Neural Network -------------------- */
	function NeuralNet(nInput, hiddenLayers, nOutput, hiddenAct, outputAct, dataMin = -1, dataMax = 1) {
		this.layers = [nInput].concat(hiddenLayers).concat([nOutput]);
		this.hiddenAct = hiddenAct;
		this.outputAct = outputAct;
		this.weights = [];
		this.biases = [];
	
		const initScheme = getSelectedInitScheme();
	
		for (let L = 0; L < this.layers.length - 1; L++) {
			let inSize = this.layers[L];
			let outSize = this.layers[L + 1];
	
			if (initScheme === "zeroToOne") {
				this.weights.push(
					Array.from({ length: outSize }, () =>
						Array.from({ length: inSize }, () => Math.random())
					)
				);
				this.biases.push(
					Array.from({ length: outSize }, () => Math.random())
				);
			} else if (initScheme === "negOneToOne") {
				this.weights.push(
					Array.from({ length: outSize }, () =>
						Array.from({ length: inSize }, () => (Math.random() * 2 - 1))
					)
				);
				this.biases.push(
					Array.from({ length: outSize }, () => (Math.random() * 2 - 1))
				);
			} else if (initScheme === "zeroOrOne") {
				this.weights.push(
					Array.from({ length: outSize }, () =>
						Array.from({ length: inSize }, () => (Math.random() < 0.5 ? 0 : 1))
					)
				);
				this.biases.push(
					Array.from({ length: outSize }, () => (Math.random() < 0.5 ? 0 : 1))
				);
			} else if (initScheme === "minmax") {
				// NEW: uniform between observed min/max of the input dataset
				const range = dataMax - dataMin;
				const sample = () => dataMin + Math.random() * range;
	
				this.weights.push(
					Array.from({ length: outSize }, () =>
						Array.from({ length: inSize }, () => sample())
					)
				);
				this.biases.push(
					Array.from({ length: outSize }, () => sample())
				);
			} else {
				// Xavier (kept as scaled [-1,1] style)
				let scale = Math.sqrt(1 / Math.max(1, inSize));
				const sample = () => (Math.random() * 2 - 1) * scale;
	
				this.weights.push(
					Array.from({ length: outSize }, () =>
						Array.from({ length: inSize }, () => sample())
					)
				);
				this.biases.push(
					Array.from({ length: outSize }, () => sample() * 0.1)
				);
			}
		}
	}
		
 NeuralNet.prototype.forward = function (input) {
 let activations = [input.slice()];
 let raws = [];

 for (let L = 0; L < this.weights.length; L++) {
 let W = this.weights[L];
 let B = this.biases[L];
 let prev = activations[L];
 let raw = W.map((row, j) => {
 let s = 0;
 for (let i = 0; i < row.length; i++) s += row[i] * prev[i];
 return s + B[j];
 });

 let isOutput = (L === this.weights.length - 1);
 let actType = isOutput ? this.outputAct : this.hiddenAct;

 let act;
 if (isOutput && this.outputAct === "softmax") {
 act = softmax(raw);
 } else {
 act = raw.map(v => act_fn(actType, v));
 }

 raws.push(raw);
 activations.push(act);
 }

 this.raws = raws;
 this.activations = activations;
 return activations[activations.length - 1];
 };

 NeuralNet.prototype.backpropSingle = function (target, trainBiases, lr) {
 let Lcount = this.weights.length;
 let activations = this.activations;
 let output = activations[activations.length - 1];

 let outGrad;
 if (this.outputAct === "softmax") {
 outGrad = output.map((o, i) => target[i] - o);
 } else {
 outGrad = output.map((o, i) => (target[i] - o) * act_deriv(this.outputAct, o));
 }

 let grads = Array(Lcount);
 grads[Lcount - 1] = outGrad;

 for (let L = Lcount - 2; L >= 0; L--) {
 let nextGrad = grads[L + 1];
 let Wnext = this.weights[L + 1];
 let err = Array(this.weights[L].length).fill(0);
 for (let j = 0; j < Wnext.length; j++) {
 for (let k = 0; k < Wnext[j].length; k++) {
 err[k] += Wnext[j][k] * nextGrad[j];
 }
 }
 let act = activations[L + 1];
 let grad = err.map((e, idx) => e * act_deriv(this.hiddenAct, act[idx]));
 grads[L] = grad;
 }

 for (let L = 0; L < Lcount; L++) {
 let grad = grads[L];
 let prevAct = activations[L];
 for (let j = 0; j < this.weights[L].length; j++) {
 if (trainBiases) this.biases[L][j] += grad[j] * lr;
 for (let i = 0; i < this.weights[L][j].length; i++) {
 this.weights[L][j][i] += grad[j] * prevAct[i] * lr;
 }
 }
 }
 };

 NeuralNet.prototype.trainBatch = function (inputs, targets, trainBiases, lr, batchSize, useCrossEntropy) {
 let total = 0;
 for (let s = 0; s < inputs.length; s++) {
 this.forward(inputs[s]);
 this.backpropSingle(targets[s], trainBiases, lr);
 if (useCrossEntropy && this.outputAct === "softmax") {
 let out = this.activations[this.activations.length - 1];
 let sampleLoss = -targets[s].reduce((acc, t, k) => acc + (t * Math.log(Math.max(1e-12, out[k]))), 0);
 total += sampleLoss;
 } else {
 let out = this.activations[this.activations.length - 1];
 let sampleLoss = targets[s].reduce((acc, t, k) => acc + Math.pow(t - out[k], 2), 0);
 total += sampleLoss;
 }
 }
 return total / inputs.length;
 };

	/* -------------------- Visualization -------------------- */
	function isDarkMode() {
		return document.body.classList.contains('dark-mode');
	}
	
	function drawNetwork(nn, sampleInput) {
		const svg = document.getElementById("nnViz");
		while (svg.firstChild) svg.removeChild(svg.firstChild);
	
		const dark = isDarkMode();
		const viewW = 1000, viewH = 480;
		const layers = nn.layers;
		const layerCount = layers.length;
		const marginX = 70;
		const usableW = viewW - marginX * 2;
		const xStep = usableW / Math.max(1, layerCount - 1);
	
		// Theme-aware colors
		const nodeFill   = dark ? "#1e293b" : "#eef6ff";
		const nodeStroke = dark ? "#94a3b8" : "#334155";
		const labelColor = dark ? "#e2e8f0" : "#1e293b";
		const biasColor  = dark ? "#94a3b8" : "#555555";
		const zeroW      = dark ? "#38bdf8" : "#2b7bd3";
		const posW       = dark ? "#4ade80" : "#2e8b57";
		const negW       = dark ? "#f87171" : "#c0392b";
	
		function layerX(idx) { return marginX + idx * xStep; }
		function layerY(count, i) {
			const top = 40, bottom = 40;
			const space = (viewH - top - bottom) / (count + 1);
			return top + space * (i + 1);
		}
	
		// Connections
		for (let L = 0; L < nn.weights.length; L++) {
			let W = nn.weights[L];
			let inCount = layers[L], outCount = layers[L + 1];
			for (let j = 0; j < outCount; j++) {
				for (let i = 0; i < inCount; i++) {
					let x1 = layerX(L), y1 = layerY(inCount, i);
					let x2 = layerX(L + 1), y2 = layerY(outCount, j);
					let w = W[j][i];
					let eps = 0.05;
					let color = Math.abs(w) < eps ? zeroW : (w >= 0 ? posW : negW);
					let width = Math.min(6, Math.max(0.6, Math.abs(w) * 2));
	
					let line = document.createElementNS("http://www.w3.org/2000/svg", "line");
					line.setAttribute("x1", x1 + 28);
					line.setAttribute("y1", y1);
					line.setAttribute("x2", x2 - 28);
					line.setAttribute("y2", y2);
					line.setAttribute("stroke", color);
					line.setAttribute("stroke-width", width);
					line.setAttribute("stroke-opacity", dark ? 0.9 : 0.85);
					svg.appendChild(line);
	
					let tx = (x1 + x2) / 2;
					let ty = (y1 + y2) / 2;
					let t = document.createElementNS("http://www.w3.org/2000/svg", "text");
					t.setAttribute("x", tx);
					t.setAttribute("y", ty - 6);
					t.setAttribute("font-size", "10");
					t.setAttribute("text-anchor", "middle");
					t.setAttribute("fill", color);
					t.textContent = w.toFixed(2);
					svg.appendChild(t);
				}
			}
		}
	
		// Nodes
		for (let L = 0; L < layers.length; L++) {
			let count = layers[L];
			for (let i = 0; i < count; i++) {
				let x = layerX(L);
				let y = layerY(count, i);
				let r = 18;
				let actVal = null;
				if (nn.activations && nn.activations[L] && nn.activations[L][i] !== undefined) {
					actVal = nn.activations[L][i];
				} else if (L === 0 && sampleInput) {
					actVal = sampleInput[i];
				} else {
					actVal = 0;
				}
	
				let circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
				circle.setAttribute("cx", x);
				circle.setAttribute("cy", y);
				circle.setAttribute("r", r);
				circle.setAttribute("fill", nodeFill);
				circle.setAttribute("stroke", nodeStroke);
				circle.setAttribute("stroke-width", "1.8");
				svg.appendChild(circle);
	
				let label = document.createElementNS("http://www.w3.org/2000/svg", "text");
				label.setAttribute("x", x);
				label.setAttribute("y", y - 26);
				label.setAttribute("font-size", "12");
				label.setAttribute("text-anchor", "middle");
				label.setAttribute("fill", labelColor);
				label.textContent = (L === 0 ? "I" + i : (L === layers.length - 1 ? "O" + i : "H" + (L - 1) + "." + i));
				svg.appendChild(label);
	
				let atext = document.createElementNS("http://www.w3.org/2000/svg", "text");
				atext.setAttribute("x", x);
				atext.setAttribute("y", y + 6);
				atext.setAttribute("font-size", "12");
				atext.setAttribute("text-anchor", "middle");
				atext.setAttribute("fill", labelColor);
				atext.textContent = (typeof actVal === "number") ? actVal.toFixed(3) : String(actVal);
				svg.appendChild(atext);
	
				if (L > 0 && nn.biases && nn.biases[L - 1] && nn.biases[L - 1][i] !== undefined) {
					let btext = document.createElementNS("http://www.w3.org/2000/svg", "text");
					btext.setAttribute("x", x);
					btext.setAttribute("y", y + 26);
					btext.setAttribute("font-size", "10");
					btext.setAttribute("text-anchor", "middle");
					btext.setAttribute("fill", biasColor);
					btext.textContent = "b:" + nn.biases[L - 1][i].toFixed(2);
					svg.appendChild(btext);
				}
			}
		}
	}
	
	/* -------------------- Loss Graph -------------------- */
	let lossData = [];
	function drawLossGraph() {
		const svg = document.getElementById("lossGraph");
		while (svg.firstChild) svg.removeChild(svg.firstChild);
		if (lossData.length === 0) return;
	
		const dark = isDarkMode();
		const W = 1000, H = 180;
		const maxLoss = Math.max(...lossData);
		const minLoss = Math.min(...lossData);
		const range = Math.max(1e-6, maxLoss - minLoss);
		const stepX = W / Math.max(1, lossData.length - 1);
	
		// Theme-aware line color
		const lineColor = dark ? "#38bdf8" : "#2563eb";
	
		let points = lossData.map((v, i) => {
			let x = i * stepX;
			let y = H - ((v - minLoss) / range) * H;
			return `${x},${y}`;
		}).join(" ");
	
		let poly = document.createElementNS("http://www.w3.org/2000/svg", "polyline");
		poly.setAttribute("points", points);
		poly.setAttribute("fill", "none");
		poly.setAttribute("stroke", lineColor);
		poly.setAttribute("stroke-width", dark ? "2.4" : "2");
		poly.setAttribute("stroke-linejoin", "round");
		svg.appendChild(poly);
	}

 /* -------------------- Training control -------------------- */
 let timer = null;
 let currentNN = null;
 let lastTrainingSettings = null; // stored for export / definition

 function computeLossForSample(nn, input, target, useCrossEntropy) {
 let out = nn.forward(input);
 if (useCrossEntropy && nn.outputAct === "softmax") {
 return -target.reduce((acc, t, k) => acc + (t * Math.log(Math.max(1e-12, out[k]))), 0);
 } else {
 return target.reduce((acc, t, k) => acc + Math.pow(t - out[k], 2), 0);
 }
 }

 function evaluateDataset(nn, inputs, targets, useCrossEntropy) {
 if (inputs.length === 0) return Infinity;
 let total = 0;
 for (let i = 0; i < inputs.length; i++) {
 total += computeLossForSample(nn, inputs[i], targets[i], useCrossEntropy);
 }
 return total / inputs.length;
 }

 function buildFullNNDefinition(nn, finalLoss, settings) {
 return {
 version: "1.1",
 timestamp: new Date().toISOString(),
 architecture: {
 layers: nn.layers,
 hiddenActivation: nn.hiddenAct,
 outputActivation: nn.outputAct
 },
 trainingSettings: {
 inputNeuronsUI: settings.nInputUI,
 outputNeuronsUI: settings.nOutputUI,
 hiddenLayers: settings.hiddenLayers,
 learningRate: settings.lr,
 stopLoss: settings.stopLoss,
 trainingSteps: settings.steps,
 logInterval: settings.logInterval,
 evaluationPercent: settings.evalPercent,
 batchSize: settings.batchSize,
 patience: settings.patience,
 lrMultiplier: settings.lrMultiplier,
 initialization: settings.initScheme,
 trainBiases: settings.trainBiases,
 shuffleData: settings.shuffleData,
 useCrossEntropy: settings.useCrossEntropy
 },
 finalMetrics: {
 finalLoss: finalLoss
 },
 weights: nn.weights,
 biases: nn.biases
 };
 }

 function finalizeTraining(nn, loss, trainInputs, trainOutputs, evalInputs, evalOutputs, settings) {
 try {
 const nnDef = buildFullNNDefinition(nn, loss, settings);
 lastTrainingSettings = settings;
 document.getElementById("nnDef").textContent =
 "NN_DEFINITION_START\n" + JSON.stringify(nnDef, null, 2) + "\nNN_DEFINITION_END";
 } catch (e) {
 console.error("Failed to write NN definition:", e);
 }

 const outEl = document.getElementById("testResults");
 if (!evalInputs || evalInputs.length === 0) {
 outEl.textContent = "No evaluation set (evaluation percent = 0 or dataset too small).";
 return;
 }

 const fmt = arr => "[" + arr.map(v => (typeof v === "number" ? (+v.toFixed(4)) : v)).join(",") + "]";

 let results = "EVALUATION_RESULTS_START\n";
 let totalErr = 0;
 let correct = 0;
 const n = evalInputs.length;

 const usesSignedTargets = evalOutputs.some(t => t.some(v => v < 0));

 for (let i = 0; i < n; i++) {
 const inp = evalInputs[i];
 const tgt = evalOutputs[i];
 let out;
 try {
 out = nn.forward(inp);
 } catch (e) {
 results += `Sample ${i}:\n Input: ${JSON.stringify(inp)}\n Target: ${JSON.stringify(tgt)}\n Output: [forward error]\n Error: 0.000000\n\n`;
 console.error("Forward pass error on sample", i, e);
 continue;
 }

 if (!Array.isArray(out)) out = [out];

 const err = tgt.reduce((s, t, k) => {
 const o = typeof out[k] === "number" ? out[k] : 0;
 return s + Math.pow(t - o, 2);
 }, 0);
 totalErr += err;

 let isCorrect = false;
 if (usesSignedTargets) {
 const predSigns = out.map(v => (v >= 0 ? 1 : -1));
 const tgtSigns = tgt.map(v => (v >= 0 ? 1 : -1));
 isCorrect = predSigns.every((p, k) => p === tgtSigns[k]);
 } else {
 const predBins = out.map(v => (v > 0.5 ? 1 : 0));
 isCorrect = predBins.every((p, k) => p === tgt[k]);
 }
 if (isCorrect) correct++;

 results += `Sample ${i}:\n`;
 results += ` Input: ${JSON.stringify(inp)}\n`;
 results += ` Target: ${JSON.stringify(tgt)}\n`;
 results += ` Output: ${fmt(out)}\n`;
 results += ` Error: ${err.toFixed(6)}\n\n`;
 }

 const avgError = totalErr / n;
 const accuracy = (correct / n) * 100;

 results += `Average Error: ${avgError.toFixed(6)}\n`;
 results += `Accuracy: ${accuracy.toFixed(2)}%\n`;
 results += "EVALUATION_RESULTS_END";

 outEl.textContent = results;
 }

 function startTraining() {
 const nInputUI = parseInt(document.getElementById("inp").value) || 1;
 const nOutputUI = parseInt(document.getElementById("out").value) || 1;
 const hiddenLayers = document.getElementById("hid").value.split(",").map(s => parseInt(s.trim())).filter(n => !isNaN(n) && n > 0);
 const hiddenAct = document.getElementById("hiddenAct").value;
 const outputAct = document.getElementById("outputAct").value;
 let lr = parseFloat(document.getElementById("lr").value);
 const steps = parseInt(document.getElementById("steps").value);
 const stopLoss = parseFloat(document.getElementById("stopLoss").value);
 const logInterval = parseInt(document.getElementById("logInterval").value);
 const trainBiases = document.getElementById("trainBiases").checked;
 const shuffleData = document.getElementById("shuffleData").checked;
 const evalPercent = Math.max(0, Math.min(100, parseFloat(document.getElementById("evalPercent").value)));
 const batchSize = Math.max(1, parseInt(document.getElementById("batchSize").value));
 const useCrossEntropy = document.getElementById("useCrossEntropy").checked;
 const patience = Math.max(1, parseInt(document.getElementById("patience").value));
 const lrMultiplier = Math.max(0.01, parseFloat(document.getElementById("lrMultiplier").value));
 const initScheme = getSelectedInitScheme();

 const completePatternsText = document.getElementById("completePatterns").value;

 // Use Output Neurons (UI hint) as the number of trailing output columns
 const datasetOutputItems = nOutputUI;

 const logEl = document.getElementById("log");
 logEl.textContent = "";
 document.getElementById("testResults").textContent = "";
 document.getElementById("nnDef").textContent = "";

 const parsed = parseCompleteDataset(completePatternsText, datasetOutputItems);
 let trainInputs = parsed.inputs;
 let trainOutputs = parsed.outputs;

 if (trainInputs.length === 0) {
 logEl.textContent = "No valid dataset found. Please paste complete patterns.\n(Output columns taken from “Output Neurons (UI hint)” value.)\n";
 return;
 }

 let actualOutputSize = trainOutputs[0].length;
 let actualInputSize = trainInputs[0].length;

 if (actualInputSize !== nInputUI) {
 logEl.textContent += `Warning: UI Input Neurons (${nInputUI}) differs from parsed pattern input size (${actualInputSize}). Using parsed size.\n`;
 }
 if (actualOutputSize !== nOutputUI) {
 logEl.textContent += `Warning: UI Output Neurons (${nOutputUI}) differs from parsed pattern output size (${actualOutputSize}). Using parsed size.\n`;
 }

 const settings = {
 nInputUI, nOutputUI, hiddenLayers,
 hiddenAct, outputAct,
 lr, stopLoss, steps, logInterval,
 evalPercent, batchSize, patience, lrMultiplier,
 initScheme, trainBiases, shuffleData, useCrossEntropy
 };
 lastTrainingSettings = settings;

	// Compute min / max of all input values (for "general" initialization)
	let dataMin = Infinity, dataMax = -Infinity;
	for (const sample of trainInputs) {
		for (const v of sample) {
			if (typeof v === "number") {
				if (v < dataMin) dataMin = v;
				if (v > dataMax) dataMax = v;
			}
		}
	}
	if (!isFinite(dataMin) || !isFinite(dataMax) || dataMin === dataMax) {
		dataMin = -1;
		dataMax = 1; // safe fallback
	}
	
	const nn = new NeuralNet(
		actualInputSize,
		hiddenLayers,
		actualOutputSize,
		hiddenAct,
		outputAct,
		dataMin,
		dataMax
	);
	currentNN = nn;


	// ----- Show initial weights & biases in Training Log -----
	logEl.textContent += "========== INITIAL NETWORK STATE ==========\n";
	logEl.textContent += `Initialization scheme: ${initScheme}\n`;
	logEl.textContent += `Layers: [${nn.layers.join(", ")}]\n\n`;
	
	nn.weights.forEach((layerWeights, L) => {
		logEl.textContent += `--- Layer ${L} → ${L + 1} Weights ---\n`;
		layerWeights.forEach((row, j) => {
			logEl.textContent += `  Neuron ${j}: [${row.map(v => v.toFixed(4)).join(", ")}]\n`;
		});
		logEl.textContent += `  Biases: [${nn.biases[L].map(v => v.toFixed(4)).join(", ")}]\n\n`;
	});
	logEl.textContent += "========== STARTING TRAINING ==========\n\n";

 let evalInputs = [], evalOutputs = [];
 if (trainInputs.length !== trainOutputs.length) {
 logEl.textContent = "Training inputs and outputs count mismatch.\n";
 return;
 }
 let N = trainInputs.length;
 let testCount = Math.round(N * (evalPercent / 100));
 if (shuffleData) {
 shuffleInPlace(trainInputs, trainOutputs);
 }
 if (testCount > 0) {
 evalInputs = trainInputs.slice(0, testCount);
 evalOutputs = trainOutputs.slice(0, testCount);
 trainInputs = trainInputs.slice(testCount);
 trainOutputs = trainOutputs.slice(testCount);
 }

 lossData = [];
 let step = 0;
 let lastDrawStep = -1;
 let bestValLoss = Infinity;
 let stepsSinceImprovement = 0;

 if (timer) { clearInterval(timer); timer = null; }

 timer = setInterval(() => {
 const updatesPerTick = 1;
 let reportedLoss = 0;

 for (let u = 0; u < updatesPerTick; u++) {
 if (trainInputs.length === 0) {
 logEl.textContent += "No training samples after evaluation split. Reduce evaluation percent.\n";
 clearInterval(timer);
 return;
 }

 let idxStart = (step * batchSize) % trainInputs.length;
 let batchInputs = [];
 let batchTargets = [];
 for (let b = 0; b < batchSize; b++) {
 let idx = (idxStart + b) % trainInputs.length;
 batchInputs.push(trainInputs[idx]);
 batchTargets.push(trainOutputs[idx]);
 }

 reportedLoss = nn.trainBatch(batchInputs, batchTargets, trainBiases, lr, batchSize, useCrossEntropy);

 step++;
 lossData.push(reportedLoss);
 }

 if (evalInputs.length > 0 && step % logInterval === 0) {
 let valLoss = evaluateDataset(nn, evalInputs, evalOutputs, useCrossEntropy);
 logEl.textContent += `Validation Loss at step ${step}: ${valLoss.toFixed(6)}\n`;

 if (valLoss + 1e-12 < bestValLoss) {
 bestValLoss = valLoss;
 stepsSinceImprovement = 0;
 } else {
 stepsSinceImprovement += logInterval;
 if (stepsSinceImprovement >= patience) {
 lr = lr * lrMultiplier;
 logEl.textContent += `Validation plateau detected. Multiplying LR by ${lrMultiplier}. New LR: ${lr.toFixed(6)}\n`;
 stepsSinceImprovement = 0;
 }
 }
 }

 if (step % 2 === 0 && step !== lastDrawStep) {
 drawNetwork(nn, trainInputs.length > 0 ? trainInputs[0] : (evalInputs[0] || Array.from({ length: nn.layers[0] }, () => 0)));
 drawLossGraph();
 lastDrawStep = step;
 }

 if (step % logInterval === 0) {
 logEl.textContent +=
 `Step ${step} → Loss: ${reportedLoss.toFixed(6)} | LR: ${lr.toFixed(6)} | BestVal: ${bestValLoss.toFixed(6)} | Plateau: ${stepsSinceImprovement}\n`;
 logEl.scrollTop = logEl.scrollHeight;
 }

 if (!isNaN(stopLoss) && reportedLoss <= stopLoss) {
 clearInterval(timer);
 logEl.textContent += `\nTraining stopped early at step ${step} due to stop-loss (${reportedLoss.toFixed(6)} <= ${stopLoss}).\n`;
 finalizeTraining(nn, reportedLoss, trainInputs, trainOutputs, evalInputs, evalOutputs, settings);
 return;
 }

 if (step >= steps) {
 clearInterval(timer);
 logEl.textContent += `\nTraining finished at step ${step}. Final Loss: ${reportedLoss.toFixed(6)}\n`;
 finalizeTraining(nn, reportedLoss, trainInputs, trainOutputs, evalInputs, evalOutputs, settings);
 return;
 }
 }, 40);
 }

 function stopTraining() {
 if (timer) {
 clearInterval(timer);
 timer = null;
 document.getElementById("log").textContent += "\nTraining stopped by user.\n";
 }
 }

 function resetNetwork() {
 stopTraining();
 currentNN = null;
 lastTrainingSettings = null;
 lossData = [];
 drawLossGraph();
 document.getElementById("nnViz").innerHTML = "";
 document.getElementById("nnDef").textContent = "";
 document.getElementById("testResults").textContent = "";
 document.getElementById("log").textContent = "Ready. Paste patterns and click “Begin Simulation”.";
 }

 function exportNetwork() {
 if (!currentNN) {
 alert("No trained network available. Please run a simulation first.");
 return;
 }
 const settings = lastTrainingSettings || {
 nInputUI: parseInt(document.getElementById("inp").value),
 nOutputUI: parseInt(document.getElementById("out").value),
 hiddenLayers: document.getElementById("hid").value.split(",").map(s => parseInt(s.trim())).filter(n => !isNaN(n) && n > 0),
 hiddenAct: currentNN.hiddenAct,
 outputAct: currentNN.outputAct,
 lr: parseFloat(document.getElementById("lr").value),
 stopLoss: parseFloat(document.getElementById("stopLoss").value),
 steps: parseInt(document.getElementById("steps").value),
 logInterval: parseInt(document.getElementById("logInterval").value),
 evalPercent: parseFloat(document.getElementById("evalPercent").value),
 batchSize: parseInt(document.getElementById("batchSize").value),
 patience: parseInt(document.getElementById("patience").value),
 lrMultiplier: parseFloat(document.getElementById("lrMultiplier").value),
 initScheme: getSelectedInitScheme(),
 trainBiases: document.getElementById("trainBiases").checked,
 shuffleData: document.getElementById("shuffleData").checked,
 useCrossEntropy: document.getElementById("useCrossEntropy").checked
 };

 const def = buildFullNNDefinition(currentNN, null, settings);
 const blob = new Blob([JSON.stringify(def, null, 2)], { type: "application/json" });
 const url = URL.createObjectURL(blob);
 const a = document.createElement("a");
 a.href = url;
 a.download = "nn_definition_" + new Date().toISOString().slice(0,19).replace(/[:T]/g,"-") + ".json";
 document.body.appendChild(a);
 a.click();
 document.body.removeChild(a);
 URL.revokeObjectURL(url);
 }

	// ---------- Default Network ----------
	function defaultNetwork() {
		// Reset all UI controls to original defaults
		document.getElementById("inp").value = 4;
		document.getElementById("out").value = 3;
		document.getElementById("hid").value = "4";
		document.getElementById("hiddenAct").value = "relu";
		document.getElementById("outputAct").value = "softmax";
		document.getElementById("lr").value = 0.01;
		document.getElementById("stopLoss").value = 0.001;
		document.getElementById("steps").value = 5000;
		document.getElementById("logInterval").value = 100;
		document.getElementById("evalPercent").value = 20;
		document.getElementById("batchSize").value = 16;
		document.getElementById("patience").value = 200;
		document.getElementById("lrMultiplier").value = 0.5;
	
		// Initialization
		document.getElementById("initNegOneToOne").checked = true;   // or initMinMax if you renamed it
		document.getElementById("trainBiases").checked = true;
		document.getElementById("shuffleData").checked = false;
		document.getElementById("useCrossEntropy").checked = false;
	
		// Clear dataset
		document.getElementById("completePatterns").value = "";
	
		// Reset network & UI
		resetNetwork();
	
		// Re-create a fresh default network for visualization
		const nInput = 4;
		const hiddenLayers = [4];
		const nOutput = 3;
		const nn = new NeuralNet(nInput, hiddenLayers, nOutput, "relu", "softmax", -1, 1);
		currentNN = nn;
		drawNetwork(nn, Array.from({ length: nInput }, () => 0));
	
		document.getElementById("log").textContent = "Default network restored.\n";
	}
	
	// ---------- Import Network ----------
	function importNetwork() {
		const input = document.createElement("input");
		input.type = "file";
		input.accept = ".json,application/json";
		input.onchange = (e) => {
			const file = e.target.files[0];
			if (!file) return;
	
			const reader = new FileReader();
			reader.onload = (ev) => {
				try {
					const def = JSON.parse(ev.target.result);
	
					// Basic validation
					if (!def.architecture || !def.weights || !def.biases) {
						alert("Invalid network definition file.");
						return;
					}
	
					// Restore architecture
					const layers = def.architecture.layers;
					const nInput = layers[0];
					const nOutput = layers[layers.length - 1];
					const hiddenLayers = layers.slice(1, -1);
	
					document.getElementById("inp").value = nInput;
					document.getElementById("out").value = nOutput;
					document.getElementById("hid").value = hiddenLayers.join(",");
					document.getElementById("hiddenAct").value = def.architecture.hiddenActivation || "relu";
					document.getElementById("outputAct").value = def.architecture.outputActivation || "softmax";
	
					// Restore training settings if present
					if (def.trainingSettings) {
						const s = def.trainingSettings;
						if (s.learningRate !== undefined) document.getElementById("lr").value = s.learningRate;
						if (s.stopLoss !== undefined) document.getElementById("stopLoss").value = s.stopLoss;
						if (s.trainingSteps !== undefined) document.getElementById("steps").value = s.trainingSteps;
						if (s.logInterval !== undefined) document.getElementById("logInterval").value = s.logInterval;
						if (s.evaluationPercent !== undefined) document.getElementById("evalPercent").value = s.evaluationPercent;
						if (s.batchSize !== undefined) document.getElementById("batchSize").value = s.batchSize;
						if (s.patience !== undefined) document.getElementById("patience").value = s.patience;
						if (s.lrMultiplier !== undefined) document.getElementById("lrMultiplier").value = s.lrMultiplier;
						if (s.trainBiases !== undefined) document.getElementById("trainBiases").checked = s.trainBiases;
						if (s.shuffleData !== undefined) document.getElementById("shuffleData").checked = s.shuffleData;
						if (s.useCrossEntropy !== undefined) document.getElementById("useCrossEntropy").checked = s.useCrossEntropy;
	
						// Initialization scheme
						if (s.initialization) {
							const radio = document.querySelector(`input[name="initScheme"][value="${s.initialization}"]`);
							if (radio) radio.checked = true;
						}
					}
	
					// Create network and inject weights & biases
					const nn = new NeuralNet(
						nInput,
						hiddenLayers,
						nOutput,
						def.architecture.hiddenActivation || "relu",
						def.architecture.outputActivation || "softmax",
						-1, 1
					);
	
					nn.weights = def.weights;
					nn.biases = def.biases;
					currentNN = nn;
	
					// Update visualization
					drawNetwork(nn, Array.from({ length: nInput }, () => 0));
					drawLossGraph();
	
					// Show definition
					document.getElementById("nnDef").textContent =
						"NN_DEFINITION_START\n" + JSON.stringify(def, null, 2) + "\nNN_DEFINITION_END";
	
					document.getElementById("log").textContent =
						"Network successfully imported from file.\n" +
						`Layers: [${layers.join(", ")}]\n`;
	
				} catch (err) {
					console.error(err);
					alert("Failed to import network: " + err.message);
				}
			};
			reader.readAsText(file);
		};
		input.click();
	}
	
	// Wire the new buttons
	document.getElementById("defaultBtn").addEventListener("click", () => { defaultNetwork(); });
	document.getElementById("importBtn").addEventListener("click", () => { importNetwork(); });
	

 /* -------------------- UI wiring -------------------- */
 document.getElementById("startBtn").addEventListener("click", () => { startTraining(); });
 document.getElementById("stopBtn").addEventListener("click", () => { stopTraining(); });
 document.getElementById("resetBtn").addEventListener("click", () => { resetNetwork(); });
 document.getElementById("exportBtn").addEventListener("click", () => { exportNetwork(); });

 // initial draw
	(function init() {
		const nInput = parseInt(document.getElementById("inp").value) || 4;
		const hiddenLayers = document.getElementById("hid").value.split(",")
			.map(s => parseInt(s.trim())).filter(n => !isNaN(n) && n > 0);
		const nOutput = parseInt(document.getElementById("out").value) || 3;
	
		// No dataset yet → use default range
		const nn = new NeuralNet(
			nInput, hiddenLayers, nOutput,
			document.getElementById("hiddenAct").value,
			document.getElementById("outputAct").value,
			-1, 1
		);
		currentNN = nn;
		drawNetwork(nn, Array.from({ length: nInput }, () => 0));
	})();
 </script>

 <!-- Footer -->
 <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>
