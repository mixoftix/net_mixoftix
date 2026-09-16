<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Genetic Algorithm Lab (Collision Attacker)</title>
    <meta name="description" content="Find a message with the same hash as the base! Choose MD5, SHA-1, or SHA-256, then use incremental or genetic algorithm.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

    <style>
        body {
            transition: background-color 0.3s, color 0.3s;
        }
        #settingsTable td { vertical-align: top; text-align: left; }
        input, textarea { font-family: 'Courier New', monospace; padding: 4px; margin: 5px; }
        #runButton, #stopButton { font-family: 'Courier New', monospace; padding: 10px 30px; cursor: pointer; margin: 5px; }
        #calculation { font-family: 'Courier New', monospace; margin-top: 10px; text-align: left; display: inline-block; }
        .highlight { animation: fadeGreen 5s ease-out forwards; }
        @keyframes fadeGreen { 0% { background-color: #90ee90; } 100% { background-color: transparent; } }
        .final-hash { color: #ff9800; }
		code { font-family: 'Courier New', monospace; background: #f0f0f0; padding: 2px 4px; border-radius: 3px; }
		.dark-mode code { background: #333; color: #fff; }
    </style>


</head>
<body class="dark-mode">
    <header>
        <h1>Genetic Algorithm Lab</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <!-- Navigation Bar -->
    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
		Workshops /
        <a href="/workshops/ai_lab_ga.asp">Genetic Algorithm Lab</a>
    </section>

    <!-- Main Content -->
    <main>
        <!-- Introduction -->
        <section class="content-box">
            <h2>Two messages, same Hash!</h2>
            <p>
			Discover a message that matches the hash of your input! Select MD5, SHA-1, or SHA-256, and choose between an incremental search or a Genetic Algorithm (GA) to find collisions. Real-time progress updates display below, with the top-performing results showcased at the end.
			<br>
			</p>
        </section>

        <!-- The Merkle Tree -->
        <section class="content-box">
            <h2>Collison Attacker Engine..</h2>

			<table id="settingsTable">
				<thead><tr><th colspan="2">Collision Search Settings</th></tr></thead>
				<tbody>
					<tr><td><label>Base Message:</label></td><td><textarea id="baseMessage" rows="2" cols="50">Find me a collision!</textarea></td></tr>
					<tr><td><label>Hash Algorithm:</label></td><td>
						<input type="radio" id="md5" name="hashAlgorithm" value="md5" checked>
						<label for="md5">MD5</label><br>
						<input type="radio" id="sha1" name="hashAlgorithm" value="sha1">
						<label for="sha1">SHA-1</label><br>
						<input type="radio" id="sha256" name="hashAlgorithm" value="sha256">
						<label for="sha256">SHA-256</label>
					</td></tr>
					<tr><td><label>Max Attempts:</label></td><td><input type="number" id="maxAttempts" value="10000" min="100" max="1000000"></td></tr>
					<tr><td><label>Use Genetic Algorithm:</label></td><td><input type="checkbox" id="useGA" onchange="toggleGASettings()"></td></tr>
					<tr id="gaSettings" style="display: none;">
						<td><label>GA Parameters:</label></td><td>
							Population Size: <input type="number" id="populationSize" value="50" min="10" max="500"><br>
							Kill Percent: <input type="number" id="killPercent" value="50" min="10" max="90">%<br>
							Mutation Rate: <input type="number" id="mutationRate" value="10" min="1" max="50">%<br>
							Strategy:<br>
							<input type="radio" id="randomStrategy" name="gaStrategy" value="random" checked>
							<label for="randomStrategy">Random</label><br>
							<input type="radio" id="targetedStrategy" name="gaStrategy" value="targeted">
							<label for="targetedStrategy">Targeted</label>
						</td></tr>
					<tr><td colspan="2" style="text-align: center;">
						<button id="runButton" onclick="findCollision()">Start Search</button>
						<button id="stopButton" onclick="stopSearch()" disabled>Stop</button>
					</td></tr>
				</tbody>
			</table>
			<table id="resultTable">
				<thead><tr><th>Attempt</th><th>Message</th><th>Base Message</th><th>Hash</th><th>Status</th></tr></thead>
				<tbody id="tableBody"></tbody>
			</table>
		    <div id="calculation"></div>
			
        </section>

		<!-- Hamming Distance Description -->
		<section class="content-box">
			<h3>About Hamming Distance in Hash Collisions</h3>
			<p>
				Curious about how we measure how "close" two hashes are? Meet the <strong>Hamming Distance</strong>—a key tool in our collision attacker! It counts the number of bit positions where two hashes differ, helping us gauge their similarity. The fewer the differences, the closer we are to a collision. Let’s break it down:
			</p>
			<p>
				<strong>How it works:</strong><br>
				- We take two hexadecimal hash strings (like those from MD5, SHA-1, or SHA-256).<br>
				- Each hex character (e.g., <code>a</code> or <code>f</code>) represents 4 bits of the hash.<br>
				- We compare each pair of characters by converting them to numbers, using a bitwise XOR to find differing bits, and counting those differences.<br>
				- The total count is the Hamming Distance, which feeds into our similarity percentage (100% means a perfect match!).
			</p>

			<section class="cyan-box">
				<p>
					<strong>Example Calculation - 1:</strong><br><br>
					Let’s compare two MD5 hashes: <code>a1b2c3d4e5f6a7b8</code> and <code>a1b2c3d4e5f6a7b9</code>. They differ only in the last character (<code>b8</code> vs. <code>b9</code>). Here’s the step-by-step:
				</p>
				<p>
					- Focus on <code>b8</code> vs. <code>b9</code>:<br>
					&nbsp;&nbsp;- <code>b8</code> = hex <code>b*16 + 8</code> = 184 (binary: <code>10111000</code>).<br>
					&nbsp;&nbsp;- <code>b9</code> = hex <code>b*16 + 9</code> = 185 (binary: <code>10111001</code>).<br>
					&nbsp;&nbsp;- XOR: <code>184 ^ 185 = 1</code> (binary: <code>00000001</code>).<br>
					&nbsp;&nbsp;- Count 1s: The binary <code>00000001</code> has 1 bit set, so 1 bit differs.<br>
					- Other characters are identical, so the total Hamming Distance = <strong>1</strong>.<br>
					- For MD5 (128 bits), similarity = <code>100 - (1 / 128) * 100 = 100 - 0.78125 = 99.21875</code>, or <strong>99.2%</strong>.
				</p>
			</section>
			<br>
			<section class="green-box">
				<p>
					<strong>Example Calculation - 2:</strong><br><br>
					Let’s compare two partial MD5 hashes: <code>d1c2c3d4f4f6b8a</code> (15 characters) and <code>a1b2c3d4e5f6a7b9</code> (first 15 characters: <code>a1b2c3d4e5f6a7b</code>). Here’s the step-by-step:
				</p>
				<p>
					- Compare each character pair:<br>
					  - Pos 1: <code>d</code> (13 = <code>1101</code>) vs. <code>a</code> (10 = <code>1010</code>) → XOR: <code>13 ^ 10 = 7</code> (<code>0111</code>) → 3 bits differ.<br>
					  - Pos 2: <code>1</code> (1 = <code>0001</code>) vs. <code>1</code> (1 = <code>0001</code>) → XOR: <code>1 ^ 1 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 3: <code>c</code> (12 = <code>1100</code>) vs. <code>b</code> (11 = <code>1011</code>) → XOR: <code>12 ^ 11 = 7</code> (<code>0111</code>) → 3 bits differ.<br>
					  - Pos 4: <code>2</code> (2 = <code>0010</code>) vs. <code>2</code> (2 = <code>0010</code>) → XOR: <code>2 ^ 2 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 5: <code>c</code> (12 = <code>1100</code>) vs. <code>c</code> (12 = <code>1100</code>) → XOR: <code>12 ^ 12 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 6: <code>3</code> (3 = <code>0011</code>) vs. <code>3</code> (3 = <code>0011</code>) → XOR: <code>3 ^ 3 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 7: <code>d</code> (13 = <code>1101</code>) vs. <code>d</code> (13 = <code>1101</code>) → XOR: <code>13 ^ 13 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 8: <code>4</code> (4 = <code>0100</code>) vs. <code>4</code> (4 = <code>0100</code>) → XOR: <code>4 ^ 4 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 9: <code>f</code> (15 = <code>1111</code>) vs. <code>e</code> (14 = <code>1110</code>) → XOR: <code>15 ^ 14 = 1</code> (<code>0001</code>) → 1 bit differs.<br>
					  - Pos 10: <code>4</code> (4 = <code>0100</code>) vs. <code>5</code> (5 = <code>0101</code>) → XOR: <code>4 ^ 5 = 1</code> (<code>0001</code>) → 1 bit differs.<br>
					  - Pos 11: <code>f</code> (15 = <code>1111</code>) vs. <code>f</code> (15 = <code>1111</code>) → XOR: <code>15 ^ 15 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 12: <code>6</code> (6 = <code>0110</code>) vs. <code>6</code> (6 = <code>0110</code>) → XOR: <code>6 ^ 6 = 0</code> (<code>0000</code>) → 0 bits differ.<br>
					  - Pos 13: <code>b</code> (11 = <code>1011</code>) vs. <code>a</code> (10 = <code>1010</code>) → XOR: <code>11 ^ 10 = 1</code> (<code>0001</code>) → 1 bit differs.<br>
					  - Pos 14: <code>8</code> (8 = <code>1000</code>) vs. <code>7</code> (7 = <code>0111</code>) → XOR: <code>8 ^ 7 = 15</code> (<code>1111</code>) → 4 bits differ.<br>
					  - Pos 15: <code>a</code> (10 = <code>1010</code>) vs. <code>b</code> (11 = <code>1011</code>) → XOR: <code>10 ^ 11 = 1</code> (<code>0001</code>) → 1 bit differs.<br>
					- Total Hamming Distance: <code>3 + 0 + 3 + 0 + 0 + 0 + 0 + 0 + 1 + 1 + 0 + 0 + 1 + 4 + 1 = 14</code> bits.<br>
					- For a 15-character (60-bit) partial MD5 hash, similarity = <code>100 - (14 / 60) * 100 = 100 - 23.3333 = 76.6667</code>, or <strong>76.7%</strong>.<br>
					<br>
					- Note: For a full MD5 (128 bits), we’d need the remaining characters, but this shows the process for the given portion.
				</p>
			</section>

			<p>
				This distance guides our search: a lower number means we’re closer to a collision!
			</p>
		</section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this collision attack topic for <strong>Deep Inside</strong> workshop series.</p>
        </section>

    </main>

    <script>
        let previousTableValues = {};
        let isSearching = false;
        let searchTimeout;
        let startTime;

        window.onload = function() {
            toggleMode();
        };

        function toggleMode() {
            const body = document.body;
            if (document.getElementById('modeCheckbox').checked) {
                body.classList.remove('light');
                body.classList.add('dark');
            } else {
                body.classList.remove('dark');
                body.classList.add('light');
            }
        }

        function toggleGASettings() {
            document.getElementById('gaSettings').style.display = 
                document.getElementById('useGA').checked ? 'table-row' : 'none';
        }

        function md5(message) {
            function rotateLeft(x, n) { return ((x << n) | (x >>> (32 - n))) >>> 0; }
            function md5cycle(x, k) {
                let a = x[0], b = x[1], c = x[2], d = x[3];
                const F = (x, y, z) => (x & y) | (~x & z);
                const G = (x, y, z) => (x & z) | (y & ~z);
                const H = (x, y, z) => x ^ y ^ z;
                const I = (x, y, z) => y ^ (x | ~z);
                const FF = (a, b, c, d, x, s, t) => { a = (a + F(b, c, d) + x + t) >>> 0; return (rotateLeft(a, s) + b) >>> 0; };
                const GG = (a, b, c, d, x, s, t) => { a = (a + G(b, c, d) + x + t) >>> 0; return (rotateLeft(a, s) + b) >>> 0; };
                const HH = (a, b, c, d, x, s, t) => { a = (a + H(b, c, d) + x + t) >>> 0; return (rotateLeft(a, s) + b) >>> 0; };
                const II = (a, b, c, d, x, s, t) => { a = (a + I(b, c, d) + x + t) >>> 0; return (rotateLeft(a, s) + b) >>> 0; };
                a = FF(a, b, c, d, k[0], 7, 0xd76aa478); d = FF(d, a, b, c, k[1], 12, 0xe8c7b756);
                c = FF(c, d, a, b, k[2], 17, 0x242070db); b = FF(b, c, d, a, k[3], 22, 0xc1bdceee);
                a = FF(a, b, c, d, k[4], 7, 0xf57c0faf); d = FF(d, a, b, c, k[5], 12, 0x4787c62a);
                c = FF(c, d, a, b, k[6], 17, 0xa8304623); b = FF(b, c, d, a, k[7], 22, 0xfd469501);
                a = FF(a, b, c, d, k[8], 7, 0x698098d8); d = FF(d, a, b, c, k[9], 12, 0x8b44f7af);
                c = FF(c, d, a, b, k[10], 17, 0xffff5bb1); b = FF(b, c, d, a, k[11], 22, 0x895cd7be);
                a = FF(a, b, c, d, k[12], 7, 0x6b901122); d = FF(d, a, b, c, k[13], 12, 0xfd987193);
                c = FF(c, d, a, b, k[14], 17, 0xa679438e); b = FF(b, c, d, a, k[15], 22, 0x49b40821);
                a = GG(a, b, c, d, k[1], 5, 0xf61e2562); d = GG(d, a, b, c, k[6], 9, 0xc040b340);
                c = GG(c, d, a, b, k[11], 14, 0x265e5a51); b = GG(b, c, d, a, k[0], 20, 0xe9b6c7aa);
                a = GG(a, b, c, d, k[5], 5, 0xd62f105d); d = GG(d, a, b, c, k[10], 9, 0x02441453);
                c = GG(c, d, a, b, k[15], 14, 0xd8a1e681); b = GG(b, c, d, a, k[4], 20, 0xe7d3fbc8);
                a = GG(a, b, c, d, k[9], 5, 0x21e1cde6); d = GG(d, a, b, c, k[14], 9, 0xc33707d6);
                c = GG(c, d, a, b, k[3], 14, 0xf4d50d87); b = GG(b, c, d, a, k[8], 20, 0x455a14ed);
                a = GG(a, b, c, d, k[13], 5, 0xa9e3e905); d = GG(d, a, b, c, k[2], 9, 0xfcefa3f8);
                c = GG(c, d, a, b, k[7], 14, 0x676f02d9); b = GG(b, c, d, a, k[12], 20, 0x8d2a4c8a);
                a = HH(a, b, c, d, k[5], 4, 0xfffa3942); d = HH(d, a, b, c, k[8], 11, 0x8771f681);
                c = HH(c, d, a, b, k[11], 16, 0x6d9d6122); b = HH(b, c, d, k[14], 23, 0xfde5380c);
                a = HH(a, b, c, d, k[1], 4, 0xa4beea44); d = HH(d, a, b, c, k[4], 11, 0x4bdecfa9);
                c = HH(c, d, a, b, k[7], 16, 0xf6bb4b60); b = HH(b, c, d, a, k[10], 23, 0xbebfbc70);
                a = HH(a, b, c, d, k[13], 4, 0x289b7ec6); d = HH(d, a, b, c, k[0], 11, 0xeaa127fa);
                c = HH(c, d, a, b, k[3], 16, 0xd4ef3085); b = HH(b, c, d, a, k[6], 23, 0x04881d05);
                a = HH(a, b, c, d, k[9], 4, 0xd9d4d039); d = HH(d, a, b, c, k[12], 11, 0xe6db99e5);
                c = HH(c, d, a, b, k[15], 16, 0x1fa27cf8); b = HH(b, c, d, a, k[2], 23, 0xc4ac5665);
                a = II(a, b, c, d, k[0], 6, 0xf4292244); d = II(d, a, b, c, k[7], 10, 0x432aff97);
                c = II(c, d, a, b, k[14], 15, 0xab9423a7); b = II(b, c, d, a, k[5], 21, 0xfc93a039);
                a = II(a, b, c, d, k[12], 6, 0x655b59c3); d = II(d, a, b, c, k[3], 10, 0x8f0ccc92);
                c = II(c, d, a, b, k[10], 15, 0xffeff47d); b = II(b, c, d, a, k[1], 21, 0x85845dd1);
                a = II(a, b, c, d, k[8], 6, 0x6fa87e4f); d = II(d, a, b, c, k[15], 10, 0xfe2ce6e0);
                c = II(c, d, a, b, k[6], 15, 0xa3014314); b = II(b, c, d, a, k[13], 21, 0x4e0811a1);
                a = II(a, b, c, d, k[4], 6, 0xf7537e82); d = II(d, a, b, c, k[11], 10, 0xbd3af235);
                c = II(c, d, a, b, k[2], 15, 0x2ad7d2bb); b = II(b, c, d, a, k[9], 21, 0xeb86d391);
                x[0] = (x[0] + a) >>> 0; x[1] = (x[1] + b) >>> 0; x[2] = (x[2] + c) >>> 0; x[3] = (x[3] + d) >>> 0;
            }
            const msg = new TextEncoder().encode(message);
            let h0 = 0x67452301, h1 = 0xefcdab89, h2 = 0x98badcfe, h3 = 0x10325476;
            let i, w = new Array(16);
            for (i = 0; i < msg.length; i += 64) {
                for (let j = 0; j < 16; j++) {
                    w[j] = (msg[i + j * 4] << 24) | (msg[i + j * 4 + 1] << 16) |
                           (msg[i + j * 4 + 2] << 8) | (msg[i + j * 4 + 3]);
                }
                const x = [h0, h1, h2, h3];
                md5cycle(x, w);
                h0 = x[0]; h1 = x[1]; h2 = x[2]; h3 = x[3];
            }
            const len = message.length * 8;
            const padLen = (msg.length % 64 < 56 ? 56 : 120) - (msg.length % 64);
            const padded = new Uint8Array(msg.length + padLen + 8);
            padded.set(msg); padded[msg.length] = 0x80;
            for (let j = 0; j < 8; j++) padded[padded.length - 8 + j] = (len >>> (j * 8)) & 0xff;
            for (i = 0; i < padded.length; i += 64) {
                for (let j = 0; j < 16; j++) {
                    w[j] = (padded[i + j * 4] << 24) | (padded[i + j * 4 + 1] << 16) |
                           (padded[i + j * 4 + 2] << 8) | (padded[i + j * 4 + 3]);
                }
                const x = [h0, h1, h2, h3];
                md5cycle(x, w);
                h0 = x[0]; h1 = x[1]; h2 = x[2]; h3 = x[3];
            }
            return [h0, h1, h2, h3].map(x => x.toString(16).padStart(8, '0')).join('');
        }

        function sha1(message) {
            function rotateLeft(x, n) { return ((x << n) | (x >>> (32 - n))) >>> 0; }
            function sha1cycle(x, k) {
                let a = x[0], b = x[1], c = x[2], d = x[3], e = x[4];
                const F = (t, b, c, d) => (0 <= t && t <= 19) ? (b & c) | (~b & d) :
                                          (20 <= t && t <= 39) ? b ^ c ^ d :
                                          (40 <= t && t <= 59) ? (b & c) | (b & d) | (c & d) :
                                          (60 <= t && t <= 79) ? b ^ c ^ d : 0;
                const K = (t) => (0 <= t && t <= 19) ? 0x5a827999 :
                                (20 <= t && t <= 39) ? 0x6ed9eba1 :
                                (40 <= t && t <= 59) ? 0x8f1bbcdc :
                                (60 <= t && t <= 79) ? 0xca62c1d6 : 0;
                for (let t = 0; t < 80; t++) {
                    const temp = (rotateLeft(a, 5) + F(t, b, c, d) + e + k[t] + K(t)) >>> 0;
                    e = d; d = c; c = rotateLeft(b, 30); b = a; a = temp;
                }
                x[0] = (x[0] + a) >>> 0; x[1] = (x[1] + b) >>> 0; x[2] = (x[2] + c) >>> 0;
                x[3] = (x[3] + d) >>> 0; x[4] = (x[4] + e) >>> 0;
            }
            const msg = new TextEncoder().encode(message);
            let h0 = 0x67452301, h1 = 0xefcdab89, h2 = 0x98badcfe, h3 = 0x10325476, h4 = 0xc3d2e1f0;
            let i, w = new Array(80);
            for (i = 0; i < msg.length; i += 64) {
                for (let j = 0; j < 16; j++) {
                    w[j] = (msg[i + j * 4] << 24) | (msg[i + j * 4 + 1] << 16) |
                           (msg[i + j * 4 + 2] << 8) | (msg[i + j * 4 + 3]);
                }
                for (let j = 16; j < 80; j++) {
                    w[j] = rotateLeft(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
                }
                const x = [h0, h1, h2, h3, h4];
                sha1cycle(x, w);
                h0 = x[0]; h1 = x[1]; h2 = x[2]; h3 = x[3]; h4 = x[4];
            }
            const len = message.length * 8;
            const padLen = (msg.length % 64 < 56 ? 56 : 120) - (msg.length % 64);
            const padded = new Uint8Array(msg.length + padLen + 8);
            padded.set(msg); padded[msg.length] = 0x80;
            for (let j = 0; j < 8; j++) padded[padded.length - 8 + j] = (len >>> (56 - j * 8)) & 0xff;
            for (i = 0; i < padded.length; i += 64) {
                for (let j = 0; j < 16; j++) {
                    w[j] = (padded[i + j * 4] << 24) | (padded[i + j * 4 + 1] << 16) |
                           (padded[i + j * 4 + 2] << 8) | (padded[i + j * 4 + 3]);
                }
                for (let j = 16; j < 80; j++) {
                    w[j] = rotateLeft(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
                }
                const x = [h0, h1, h2, h3, h4];
                sha1cycle(x, w);
                h0 = x[0]; h1 = x[1]; h2 = x[2]; h3 = x[3]; h4 = x[4];
            }
            return [h0, h1, h2, h3, h4].map(x => x.toString(16).padStart(8, '0')).join('');
        }

        function sha256(message) {
            function rightRotate(x, n) { return (x >>> n) | (x << (32 - n)); }
            function sha256cycle(x, k) {
                let a = x[0], b = x[1], c = x[2], d = x[3], e = x[4], f = x[5], g = x[6], h = x[7];
                const K = [
                    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
                    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
                    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
                    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
                    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
                    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
                    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4eda8aac, 0x5b9cca4f, 0x682e6ff3,
                    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
                ];
                for (let t = 0; t < 64; t++) {
                    const s0 = rightRotate(a, 2) ^ rightRotate(a, 13) ^ rightRotate(a, 22);
                    const maj = (a & b) ^ (a & c) ^ (b & c);
                    const t2 = (s0 + maj) >>> 0;
                    const s1 = rightRotate(e, 6) ^ rightRotate(e, 11) ^ rightRotate(e, 25);
                    const ch = (e & f) ^ (~e & g);
                    const t1 = (h + s1 + ch + K[t] + k[t]) >>> 0;
                    h = g; g = f; f = e; e = (d + t1) >>> 0; d = c; c = b; b = a; a = (t1 + t2) >>> 0;
                }
                x[0] = (x[0] + a) >>> 0; x[1] = (x[1] + b) >>> 0; x[2] = (x[2] + c) >>> 0; x[3] = (x[3] + d) >>> 0;
                x[4] = (x[4] + e) >>> 0; x[5] = (x[5] + f) >>> 0; x[6] = (x[6] + g) >>> 0; x[7] = (x[7] + h) >>> 0;
            }
            const msg = new TextEncoder().encode(message);
            let h0 = 0x6a09e667, h1 = 0xbb67ae85, h2 = 0x3c6ef372, h3 = 0xa54ff53a,
                h4 = 0x510e527f, h5 = 0x9b05688c, h6 = 0x1f83d9ab, h7 = 0x5be0cd19;
            let i, w = new Array(64);
            for (i = 0; i < msg.length; i += 64) {
                for (let j = 0; j < 16; j++) {
                    w[j] = (msg[i + j * 4] << 24) | (msg[i + j * 4 + 1] << 16) |
                           (msg[i + j * 4 + 2] << 8) | (msg[i + j * 4 + 3]);
                }
                for (let j = 16; j < 64; j++) {
                    const s0 = rightRotate(w[j-15], 7) ^ rightRotate(w[j-15], 18) ^ (w[j-15] >>> 3);
                    const s1 = rightRotate(w[j-2], 17) ^ rightRotate(w[j-2], 19) ^ (w[j-2] >>> 10);
                    w[j] = (w[j-16] + s0 + w[j-7] + s1) >>> 0;
                }
                const x = [h0, h1, h2, h3, h4, h5, h6, h7];
                sha256cycle(x, w);
                h0 = x[0]; h1 = x[1]; h2 = x[2]; h3 = x[3]; h4 = x[4]; h5 = x[5]; h6 = x[6]; h7 = x[7];
            }
            const len = message.length * 8;
            const padLen = (msg.length % 64 < 56 ? 56 : 120) - (msg.length % 64);
            const padded = new Uint8Array(msg.length + padLen + 8);
            padded.set(msg); padded[msg.length] = 0x80;
            for (let j = 0; j < 8; j++) padded[padded.length - 8 + j] = (len >>> (56 - j * 8)) & 0xff;
            for (i = 0; i < padded.length; i += 64) {
                for (let j = 0; j < 16; j++) {
                    w[j] = (padded[i + j * 4] << 24) | (padded[i + j * 4 + 1] << 16) |
                           (padded[i + j * 4 + 2] << 8) | (padded[i + j * 4 + 3]);
                }
                for (let j = 16; j < 64; j++) {
                    const s0 = rightRotate(w[j-15], 7) ^ rightRotate(w[j-15], 18) ^ (w[j-15] >>> 3);
                    const s1 = rightRotate(w[j-2], 17) ^ rightRotate(w[j-2], 19) ^ (w[j-2] >>> 10);
                    w[j] = (w[j-16] + s0 + w[j-7] + s1) >>> 0;
                }
                const x = [h0, h1, h2, h3, h4, h5, h6, h7];
                sha256cycle(x, w);
                h0 = x[0]; h1 = x[1]; h2 = x[2]; h3 = x[3]; h4 = x[4]; h5 = x[5]; h6 = x[6]; h7 = x[7];
            }
            return [h0, h1, h2, h3, h4, h5, h6, h7].map(x => x.toString(16).padStart(8, '0')).join('');
        }

        function hammingDistance(hash1, hash2, digestSize) {
            let distance = 0;
            for (let i = 0; i < hash1.length; i++) {
                const byte1 = parseInt(hash1[i], 16);
                const byte2 = parseInt(hash2[i], 16);
                distance += (byte1 ^ byte2).toString(2).split('1').length - 1;
            }
            return distance;
        }

        function fitnessSimilarity(hash, baseHash, digestSize) {
            const maxBits = digestSize;
            const distance = hammingDistance(hash, baseHash, digestSize);
            return (100 - (distance / maxBits) * 100).toFixed(1) + '%';
        }

        function generateIncrementalMessage(base, counter) {
            return base + counter;
        }

        function generateRandomMessage(base) {
            const suffixLength = base.length;
            return base + Array(suffixLength).fill().map(() => String.fromCharCode(Math.floor(Math.random() * 256))).join('');
        }

        function mutateRandom(message, mutationRate) {
            let result = message.split('');
            const suffixLength = message.length / 2;
            for (let i = message.length - suffixLength; i < message.length; i++) {
                if (Math.random() < mutationRate / 100) {
                    result[i] = String.fromCharCode(Math.floor(Math.random() * 256));
                }
            }
            return result.join('');
        }

        function mutateTargeted(message, mutationRate, bestMsg) {
            let result = message.split('');
            const suffixLength = message.length - bestMsg.length + bestMsg.length;
            const baseBits = bestMsg.split('');
            for (let i = message.length - suffixLength; i < message.length; i++) {
                const mutateChance = (result[i] === baseBits[i]) ? mutationRate / 100 : mutationRate / 50;
                if (Math.random() < mutateChance) {
                    result[i] = String.fromCharCode(Math.floor(Math.random() * 256));
                }
            }
            return result.join('');
        }

        function crossover(parent1, parent2) {
            const baseLength = parent1.length - (parent1.length / 2);
            const split = Math.floor(Math.random() * (parent1.length - baseLength)) + baseLength;
            return parent1.slice(0, split) + parent2.slice(split);
        }

        function displayTopResults(finalCandidates, hashAlgorithm, baseHash, digestSize, generation) {
            const topCount = Math.min(5, finalCandidates.length);
            let tableHTML = '<br><table><thead><tr><th>Rank</th><th>Message</th><th>' + hashAlgorithm.toUpperCase() + ' Hash</th><th>Fitness (% Similarity)</th></tr></thead><tbody>';
            for (let i = 0; i < topCount; i++) {
                tableHTML += `<tr><td>${i + 1}</td><td>${finalCandidates[i].msg}</td><td>${finalCandidates[i].hash}</td><td>${fitnessSimilarity(finalCandidates[i].hash, baseHash, digestSize)}</td></tr>`;
            }
            tableHTML += '</tbody></table>';
            return `<br>Top ${topCount} Best Results${generation !== undefined ? ` (Generation ${generation})` : ''}:${tableHTML}`;
        }

        function findCollision() {
            if (isSearching) return;
            isSearching = true;
            startTime = performance.now();
            document.getElementById('runButton').disabled = true;
            document.getElementById('stopButton').disabled = false;

            const baseMessage = document.getElementById('baseMessage').value;
            const hashAlgorithm = document.querySelector('input[name="hashAlgorithm"]:checked').value;
            const maxAttempts = parseInt(document.getElementById('maxAttempts').value);
            const useGA = document.getElementById('useGA').checked;
            const populationSize = parseInt(document.getElementById('populationSize').value);
            const killPercent = parseInt(document.getElementById('killPercent').value);
            const mutationRate = parseInt(document.getElementById('mutationRate').value);
            const strategy = document.querySelector('input[name="gaStrategy"]:checked').value;
            const tableBody = document.getElementById('tableBody');
            const calcDiv = document.getElementById('calculation');
            let attempts = 0;
            const candidates = [];

            const digestSize = hashAlgorithm === 'md5' ? 128 : hashAlgorithm === 'sha1' ? 160 : 256;
            const hashFunc = hashAlgorithm === 'md5' ? md5 : hashAlgorithm === 'sha1' ? sha1 : sha256;
            const baseHash = hashFunc(baseMessage);

            tableBody.innerHTML = '';
            calcDiv.innerHTML = `Searching for ${hashAlgorithm.toUpperCase()} collision (${useGA ? 'GA' : 'Incremental'})...<br>Base Message: "${baseMessage}"<br>Base ${hashAlgorithm.toUpperCase()}: <span class="final-hash">${baseHash}</span>${useGA ? `<br>Strategy: ${strategy}` : ''}`;

            if (!useGA) {
                function bruteForceStep() {
                    if (!isSearching || attempts >= maxAttempts) {
                        stopSearch();
                        const finalCandidates = candidates.sort((a, b) => a.fitness - b.fitness).slice(0, 5);
                        calcDiv.innerHTML += attempts >= maxAttempts ?
                            `<br>No collision found after ${maxAttempts} attempts.` :
                            `<br>Search stopped at ${attempts} attempts.`;
                        calcDiv.innerHTML += displayTopResults(finalCandidates, hashAlgorithm, baseHash, digestSize);
                        displayResult(attempts, finalCandidates[0].msg, baseMessage, finalCandidates[0].hash, `Best Fitness: ${fitnessSimilarity(finalCandidates[0].hash, baseHash, digestSize)}`);
                        return;
                    }
                    const msg = generateIncrementalMessage(baseMessage, attempts);
                    const hash = hashFunc(msg);
                    const fitness = hammingDistance(hash, baseHash, digestSize);
                    attempts++;
                    if (!candidates.some(c => c.hash === hash)) candidates.push({ msg, hash, fitness });
                    if (hash === baseHash && msg !== baseMessage) {
                        stopSearch();
                        calcDiv.innerHTML += `<br>Collision found after ${attempts} attempts!<br>Colliding Message: "${msg}"<br>Hash: <span class="final-hash">${hash}</span>`;
                        calcDiv.innerHTML += displayTopResults(candidates.sort((a, b) => a.fitness - b.fitness).slice(0, 5), hashAlgorithm, baseHash, digestSize);
                        displayResult(attempts, msg, baseMessage, hash, 'Collision Found!');
                        return;
                    }
                    if (attempts % 100 === 0) {
                        const tempCandidates = candidates.sort((a, b) => a.fitness - b.fitness).slice(0, 5);
                        displayResult(attempts, tempCandidates[0].msg, baseMessage, tempCandidates[0].hash, `Searching... Best Fitness: ${fitnessSimilarity(tempCandidates[0].hash, baseHash, digestSize)}`);
                    }
                    searchTimeout = setTimeout(bruteForceStep, 0);
                }
                bruteForceStep();
            } else {
                let population = Array(populationSize).fill().map(() => generateRandomMessage(baseMessage));
                let generation = 0;
                function gaStep() {
                    if (!isSearching || attempts >= maxAttempts) {
                        stopSearch();
                        const finalCandidates = [...new Set(population)].map(msg => ({
                            msg,
                            hash: hashFunc(msg),
                            fitness: hammingDistance(hashFunc(msg), baseHash, digestSize)
                        })).sort((a, b) => a.fitness - b.fitness);
                        calcDiv.innerHTML += attempts >= maxAttempts ?
                            `<br>No collision found after ${maxAttempts} attempts.` :
                            `<br>Search stopped at ${attempts} attempts.`;
                        calcDiv.innerHTML += displayTopResults(finalCandidates, hashAlgorithm, baseHash, digestSize, generation);
                        displayResult(attempts, finalCandidates[0].msg, baseMessage, finalCandidates[0].hash, `Best Fitness: ${fitnessSimilarity(finalCandidates[0].hash, baseHash, digestSize)}`);
                        return;
                    }
                    const individuals = population.map(msg => ({
                        msg,
                        hash: hashFunc(msg),
                        fitness: hammingDistance(hashFunc(msg), baseHash, digestSize)
                    }));
                    attempts += populationSize;
                    for (let i = 0; i < individuals.length; i++) {
                        if (individuals[i].hash === baseHash && individuals[i].msg !== baseMessage) {
                            stopSearch();
                            calcDiv.innerHTML += `<br>Collision found after ${attempts} attempts (Generation ${generation})!<br>Colliding Message: "${individuals[i].msg}"<br>Hash: <span class="final-hash">${baseHash}</span>`;
                            calcDiv.innerHTML += displayTopResults(individuals, hashAlgorithm, baseHash, digestSize, generation);
                            displayResult(attempts, individuals[i].msg, baseMessage, baseHash, 'Collision Found!');
                            return;
                        }
                    }
                    individuals.sort((a, b) => a.fitness - b.fitness);
                    const survivors = individuals.slice(0, Math.ceil(individuals.length * (1 - killPercent / 100)));
                    const bestMsg = survivors[0].msg;
                    population = [...survivors.map(ind => ind.msg)];
                    while (population.length < populationSize) {
                        const parent1 = survivors[Math.floor(Math.random() * survivors.length)].msg;
                        const parent2 = survivors[Math.floor(Math.random() * survivors.length)].msg;
                        let offspring = crossover(parent1, parent2);
                        offspring = (strategy === 'random') ? 
                            mutateRandom(offspring, mutationRate) : 
                            mutateTargeted(offspring, mutationRate, bestMsg);
                        while (population.includes(offspring)) {
                            offspring = crossover(parent1, parent2);
                            offspring = (strategy === 'random') ? 
                                mutateRandom(offspring, mutationRate) : 
                                mutateTargeted(offspring, mutationRate, bestMsg);
                        }
                        population.push(offspring);
                    }
                    generation++;
                    if (generation % 10 === 0) {
                        displayResult(attempts, individuals[0].msg, baseMessage, individuals[0].hash, `Generation ${generation}, Best Fitness: ${fitnessSimilarity(individuals[0].hash, baseHash, digestSize)}`);
                    }
                    searchTimeout = setTimeout(gaStep, 0);
                }
                gaStep();
            }

			function displayResult(attempts, msg, baseMsg, hash, status) {
				const row = document.createElement('tr');
				row.innerHTML = `
					<td id="attempt_${attempts}">${attempts}</td>
					<td id="msg_${attempts}">${msg}</”:wtd>
					<td id="baseMsg_${attempts}">${baseMsg}</td>
					<td id="hash_${attempts}">${hash}</td>
					<td id="status_${attempts}">${status}</td>
				`;
				tableBody.innerHTML = '';
				tableBody.appendChild(row);
				['attempt', 'msg', 'baseMsg', 'hash', 'status'].forEach(col => {
					const elementId = `${col}_${attempts}`;
					const element = document.getElementById(elementId);
					const newValue = element.innerHTML;
					const prevValue = previousTableValues[elementId] || '';
					if (newValue !== prevValue) {
						element.classList.remove('highlight');
						void element.offsetWidth;
						element.classList.add('highlight');
						previousTableValues[elementId] = newValue;
					}
				});
			}

        }

        function stopSearch() {
            if (!isSearching) return;
            isSearching = false;
            clearTimeout(searchTimeout);
            const endTime = performance.now();
            const elapsedTime = ((endTime - startTime) / 1000).toFixed(2);
            document.getElementById('calculation').innerHTML += `<br>Search completed in ${elapsedTime} seconds.`;
            document.getElementById('runButton').disabled = false;
            document.getElementById('stopButton').disabled = true;
        }
    </script>


    <!-- Footer -->
    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>