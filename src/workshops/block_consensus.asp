<!DOCTYPE html>
<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Block Forks and Consensus</title>
    <meta name="description" content="Explore difficulty and forks in Proof of Work blockchains through an interactive simulation.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

    <style>
        body {
            transition: background-color 0.1s, color 0.1s;
        }
        .subtitle {
            font-size: 0.9em;
            margin-top: 0;
            margin-bottom: 5px;
        }
        .blockTable, .forkTable {
            font-family: 'Courier New', monospace;
            border-collapse: collapse;
            margin: 20px auto;
            width: 90%;
        }
        .blockTable th, .blockTable td, .forkTable th, .forkTable td {
            font-family: 'Courier New', monospace;
            padding: 8px;
            text-align: left;
            vertical-align: top;
            border: 1px solid #ccc;
        }
        .text {
            font-size: 1em;
            line-height: 1.5;
            margin-bottom: 20px;
        }
        .input-container {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        input {
            font-family: 'Courier New', monospace;
            padding: 4px;
            margin-right: 4px;
        }
        .control-btn {
            font-family: 'Courier New', monospace;
            padding: 4px 10px;
            cursor: pointer;
            margin: 0 4px;
            border: 1px solid #ccc;
            background-color: #f0f0f0;
        }
        .control-btn:hover {
            background-color: #e0e0e0;
        }
        .control-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        .block-data {
            white-space: pre-line;
        }
        .highlight {
            animation: fadeGreen 3s ease-out forwards;
        }
        @keyframes fadeGreen {
            0% { background-color: #90ee90; }
            100% { background-color: transparent; }
        }
        .winner-highlight {
            background-color: #90ee90 !important; /* Fixed green color for winners */
        }
        .dark-mode .winner-highlight {
            color: #000000; /* Black font for readability in dark mode */
        }
        .winners {
            font-family: 'Courier New', monospace;
            text-align: center;
            margin: 10px auto;
            font-size: 1em;
            color: #333;
        }
        .dark-mode .winners {
            color: #ccc;
        }
        .radio-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        input:disabled {
            background-color: #e0e0e0;
            cursor: not-allowed;
        }
        .verify-btn {
            font-family: 'Courier New', monospace;
            padding: 2px 6px;
            margin-top: 5px;
            cursor: pointer;
            border: 1px solid #ccc;
            background-color: #f0f0f0;
            font-size: 0.8em;
        }
        .verify-btn:hover {
            background-color: #e0e0e0;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            max-width: 600px;
            font-family: 'Courier New', monospace;
            white-space: pre-wrap;
            overflow-x: auto;
        }
        .dark-mode .modal-content {
            background-color: #333;
            color: #ccc;
        }
        .close-btn {
            float: right;
            cursor: pointer;
            font-size: 1.2em;
        }
    </style>
</head>
<body class="dark-mode">
    <header>
        <h1>Block Forks and Consensus</h1>
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
        <a href="/workshops/block_consensus.asp">Block Forks and Consensus</a>
    </section>

    <!-- Main Content -->
    <main>
        <!-- Introduction -->
        <section class="content-box">
            <h2>Understanding Difficulty and Forks</h2>
            <p>
                In Proof of Work (PoW), miners compete to find a block hash that meets the difficulty target by adjusting a nonce. The difficulty determines how many leading zeros the hash must have. Forks occur when multiple miners solve a block simultaneously, creating competing chains.
            </p>
        </section>

        <!-- Block Setup -->
        <section class="content-box">
            <h2>Blockchain Simulation</h2>

            <!-- Block 1001 -->
            <table class="blockTable" id="blockTable">
                <tr>
                    <th>Field</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Block Number</td>
                    <td id="blockNumber">1001</td>
                </tr>
                <tr>
                    <td>Hash Algorithm</td>
                    <td>
                        <div class="radio-container">
                            <label><input type="radio" name="hashAlgo" id="md5" value="md5" checked onclick="updateBlock1001Hash()"> MD5</label>
                            <label><input type="radio" name="hashAlgo" id="sha256" value="sha256" onclick="updateBlock1001Hash()"> SHA256</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Difficulty (Leading Zeros)</td>
                    <td>
                        <div class="input-container">
                            <input id="difficulty" type="number" value="3" min="1" max="8" oninput="updateBlock1001Hash()">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Block Hash</td>
                    <td id="blockHash"></td>
                </tr>
            </table>

            <div class="input-container">
                <button class="control-btn" id="calcBtn" onclick="startSimulation()">Start Simulation</button>
                <button class="control-btn" onclick="stopSimulation()" disabled id="stopBtn">Stop Simulation</button>
                <button class="control-btn" id="resetBtn" onclick="resetSimulation()">Reset Simulation</button>
            </div>
        </section>

        <!-- Forks Display -->
        <section class="content-box">
            <h2>Fork Competition</h2>
            <table class="forkTable" id="forkTable">
                <tr>
                    <th>Block Number</th>
                    <th>Miner 1</th>
                    <th>Miner 2</th>
                    <th>Miner 3</th>
                </tr>
            </table>
            <div class="winners" id="winners">Winning Miners: None</div>
        </section>

        <!-- Simplified vs. Bitcoin Difficulty -->
        <section class="content-box">
            <h2>Simplified vs. Bitcoin Difficulty</h2>
            <p>
                This simulation uses a simple way to measure difficulty, but Bitcoin’s method is more complex. Here’s how they differ, explained for students:
            </p>
            <h3>Simplified Difficulty (This Simulation)</h3>
            <p>
                In this simulation, difficulty means how many zeros must appear at the start of a hash. For example, if difficulty is 4, the hash must start with “0000”. Miners try different nonces (numbers) until they find a hash with enough leading zeros.
            </p>
            <p>
                <strong>Example</strong>: Suppose we hash “1002 + Merkle Root + Previous Block + Nonce” with MD5. We want 4 leading zeros (difficulty 4). After trying nonces, we find:
            </p>
            <section class="cyan-box">
            Nonce: 12345
            <br>
            Hash: 0000a1b2c3d4e5f67890123456789abc
            <br>
            Result: Success! The hash starts with “0000”.
            </section>
            <p>
                This is like guessing a code that starts with four zeros—easy to understand but not exactly how Bitcoin works.
            </p>
            <h3>Bitcoin’s Difficulty</h3>
            <p>
                Bitcoin uses a “target” number. The hash of a block header must be less than or equal to this target. A smaller target means higher difficulty, and small targets produce hashes with many leading zeros. Bitcoin adjusts the target every 2016 blocks (about 2 weeks) to keep blocks coming every 10 minutes.
            </p>
            <p>
                <strong>Example</strong>: Imagine Bitcoin’s target is a small number, like 0000000000000000001f (in hex, a 256-bit number - so the actual full target is: 0000000000000000001f00000000000000000000000000000000000000000000). The miner hashes the block header (version, previous block, Merkle root, timestamp, bits, nonce) with double SHA256. After trying nonces, they find:
            </p>
            <section class="cyan-box">
            Nonce: 987654
            <br>
            Hash: 0000000000000000000a1b2c3d4e5f...
            <br>
            Result: Success! The hash is less than the target (0000000000000000001f...).
            </section>
            <p>
                This is like a game where you roll a huge dice (256 bits) and need a number smaller than a tiny target. The smaller the target, the more leading zeros the hash tends to have.
            </p>
            <h3>Key Differences</h3>
            <ul>
                <li><strong>Metric</strong>: Simulation uses leading zeros (e.g., 4 zeros). Bitcoin uses a numerical target (hash must be below it).</li>
                <li><strong>Adjustment</strong>: Simulation’s difficulty is fixed or manual. Bitcoin adjusts difficulty automatically every 2016 blocks.</li>
                <li><strong>Input</strong>: Simulation hashes a simple string (Block Number + Merkle Root + Previous Block + Nonce). Bitcoin hashes a full block header with more fields.</li>
                <li><strong>Hash Function</strong>: Simulation uses single MD5 or SHA256. Bitcoin uses double SHA256 (SHA256(SHA256(header))).</li>
            </ul>
            <p>
                The simulation makes difficulty easy to visualize with leading zeros, while Bitcoin’s target system is more precise and flexible for a real-world network.
            </p>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its invaluable assistance in creating this PoW topic for <strong>Deep Inside</strong> workshop series.</p>
        </section>
    </main>

    <!-- Modal for Verification -->
    <div id="verifyModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal()">×</span>
            <div id="verifyContent"></div>
        </div>
    </div>

    <script>
        let simulationRunning = false;
        let blocks = [];
        let timeoutId = null;
        let currentBlockNumber = 1002;
        let block1001Hash = '';
        let winnerChain = []; // Store the winning chain

        // Toggle dark mode
        function toggleDarkMode() {
            document.body.classList.toggle('dark-mode');
        }

        // Generate random hex string
        function randomHex(length) {
            let result = '';
            const chars = '0123456789abcdef';
            for (let i = 0; i < length; i++) {
                result += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return result;
        }

        // Generate random hash or Merkle Root
        function generateRandomHash(difficulty, isMerkleRoot = false) {
            const algo = document.querySelector('input[name="hashAlgo"]:checked').value;
            const totalLength = algo === 'sha256' ? 64 : 32;
            if (isMerkleRoot) {
                return randomHex(totalLength);
            }
            const zeros = '0'.repeat(difficulty);
            const remainingLength = totalLength - difficulty;
            return zeros + randomHex(remainingLength);
        }

        // Check if hash meets difficulty
        function meetsDifficulty(hash, difficulty) {
            return hash.startsWith('0'.repeat(difficulty));
        }

        // MD5 function (fixed implementation)
        function md5(message) {
            const K = [
                0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a, 0xa8304623, 0xfd469501,
                0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
                0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
                0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
                0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
                0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
                0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
                0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
            ];
            const S = [
                7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
            ];
            function rotateLeft(x, n) {
                return ((x << n) | (x >>> (32 - n))) >>> 0;
            }
            function F(x, y, z) { return (x & y) | (~x & z); }
            function G(x, y, z) { return (x & z) | (y & ~z); }
            function H(x, y, z) { return x ^ y ^ z; }
            function I(x, y, z) { return y ^ (x | ~z); }
            let h0 = 0x67452301, h1 = 0xefcdab89, h2 = 0x98badcfe, h3 = 0x10325476;
            const msg = new TextEncoder().encode(message);
            const len = msg.length * 8;
            const padLen = (msg.length % 64 < 56 ? 56 : 120) - (msg.length % 64);
            const padded = new Uint8Array(msg.length + padLen + 8);
            padded.set(msg);
            padded[msg.length] = 0x80;
            for (let i = 0; i < 8; i++) {
                padded[padded.length - 8 + i] = (len >>> (56 - i * 8)) & 0xff;
            }
            for (let i = 0; i < padded.length; i += 64) {
                const w = new Array(16);
                for (let j = 0; j < 16; j++) {
                    w[j] = (padded[i + j * 4] << 24) | (padded[i + j * 4 + 1] << 16) |
                           (padded[i + j * 4 + 2] << 8) | (padded[i + j * 4 + 3]);
                }
                let a = h0, b = h1, c = h2, d = h3;
                for (let j = 0; j < 64; j++) {
                    let f, k, temp;
                    if (j < 16) {
                        f = F(b, c, d);
                        k = j;
                    } else if (j < 32) {
                        f = G(b, c, d);
                        k = (5 * j + 1) % 16;
                    } else if (j < 48) {
                        f = H(b, c, d);
                        k = (3 * j + 5) % 16;
                    } else {
                        f = I(b, c, d);
                        k = (7 * j) % 16;
                    }
                    temp = d;
                    d = c;
                    c = b;
                    b = (b + rotateLeft((a + f + K[j] + w[k]) >>> 0, S[j])) >>> 0;
                    a = temp;
                }
                h0 = (h0 + a) >>> 0;
                h1 = (h1 + b) >>> 0;
                h2 = (h2 + c) >>> 0;
                h3 = (h3 + d) >>> 0;
            }
            return [h0, h1, h2, h3].map(x => {
                const hex = x.toString(16).padStart(8, '0');
                return hex.match(/.{2}/g).reverse().join('');
            }).join('');
        }

        // SHA256 function
        function sha256(message) {
            function rightRotate(x, n) { return (x >>> n) | (x << (32 - n)); }
            const K = [
                0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
                0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
                0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
                0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
                0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
                0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
                0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
                0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
            ];
            const msg = new TextEncoder().encode(message);
            const len = msg.length * 8;
            const padLen = (msg.length % 64 < 56 ? 56 : 120) - (msg.length % 64);
            const padded = new Uint8Array(msg.length + padLen + 8);
            padded.set(msg); padded[msg.length] = 0x80;
            for (let j = 0; j < 8; j++) padded[padded.length - 8 + j] = (len >>> (56 - j * 8)) & 0xff;
            let h0 = 0x6a09e667, h1 = 0xbb67ae85, h2 = 0x3c6ef372, h3 = 0xa54ff53a,
                h4 = 0x510e527f, h5 = 0x9b05688c, h6 = 0x1f83d9ab, h7 = 0x5be0cd19;
            for (let i = 0; i < padded.length; i += 64) {
                const w = new Array(64);
                for (let j = 0; j < 16; j++) {
                    w[j] = (padded[i + j * 4] << 24) | (padded[i + j * 4 + 1] << 16) |
                           (padded[i + j * 4 + 2] << 8) | (padded[i + j * 4 + 3]);
                }
                for (let j = 16; j < 64; j++) {
                    const s0 = rightRotate(w[j - 15], 7) ^ rightRotate(w[j - 15], 18) ^ (w[j - 15] >>> 3);
                    const s1 = rightRotate(w[j - 2], 17) ^ rightRotate(w[j - 2], 19) ^ (w[j - 2] >>> 10);
                    w[j] = (w[j - 16] + s0 + w[j - 7] + s1) >>> 0;
                }
                let a = h0, b = h1, c = h2, d = h3, e = h4, f = h5, g = h6, h = h7;
                for (let j = 0; j < 64; j++) {
                    const S1 = rightRotate(e, 6) ^ rightRotate(e, 11) ^ rightRotate(e, 25);
                    const ch = (e & f) ^ (~e & g);
                    const temp1 = (h + S1 + ch + K[j] + w[j]) >>> 0;
                    const S0 = rightRotate(a, 2) ^ rightRotate(a, 13) ^ rightRotate(a, 22);
                    const maj = (a & b) ^ (a & c) ^ (b & c);
                    const temp2 = (S0 + maj) >>> 0;
                    h = g; g = f; f = e; e = (d + temp1) >>> 0;
                    d = c; c = b; b = a; a = (temp1 + temp2) >>> 0;
                }
                h0 = (h0 + a) >>> 0; h1 = (h1 + b) >>> 0; h2 = (h2 + c) >>> 0; h3 = (h3 + d) >>> 0;
                h4 = (h4 + e) >>> 0; h5 = (h5 + f) >>> 0; h6 = (h6 + g) >>> 0; h7 = (h7 + h) >>> 0;
            }
            return [h0, h1, h2, h3, h4, h5, h6, h7].map(x => x.toString(16).padStart(8, '0')).join('');
        }

        // Generic hash function
        function hash(message) {
            const algo = document.querySelector('input[name="hashAlgo"]:checked').value;
            return algo === 'sha256' ? sha256(message) : md5(message);
        }

        // Update block 1001 hash
        function updateBlock1001Hash() {
            const difficulty = parseInt(document.getElementById('difficulty').value) || 4;
            block1001Hash = generateRandomHash(difficulty);
            document.getElementById('blockHash').textContent = block1001Hash;
        }

        // Simulate mining
        function mineBlock(rootHash, prevHash, difficulty, blockNum) {
            let nonce = Math.floor(Math.random() * 1000000);
            let attempts = 0;
            const maxAttempts = 200000;
            const dataPrefix = blockNum === 1001 ? `${blockNum}${rootHash}` : `${blockNum}${rootHash}${prevHash}`;
            while (attempts < maxAttempts) {
                const data = `${dataPrefix}${nonce}`;
                const hashResult = hash(data);
                if (meetsDifficulty(hashResult, difficulty)) {
                    console.log(`Mining succeeded for block ${blockNum}, nonce ${nonce}, attempts ${attempts}`);
                    return { nonce, hash: hashResult, success: true };
                }
                nonce++;
                attempts++;
            }
            nonce = Math.floor(Math.random() * 2000000) + 1000000;
            attempts = 0;
            while (attempts < maxAttempts) {
                const data = `${dataPrefix}${nonce}`;
                const hashResult = hash(data);
                if (meetsDifficulty(hashResult, difficulty)) {
                    console.log(`Mining succeeded for block ${blockNum}, nonce ${nonce}, attempts ${attempts} (fallback)`);
                    return { nonce, hash: hashResult, success: true };
                }
                nonce++;
                attempts++;
            }
            console.log(`Mining failed for block ${blockNum}, difficulty ${difficulty}, last nonce ${nonce}`);
            return { nonce, success: false };
        }

        // Highlight changed elements
        function highlightChange(element) {
            element.classList.remove('highlight');
            void element.offsetWidth;
            element.classList.add('highlight');
        }

        // Find the winning chain
        function findWinnerChain() {
            winnerChain = [];
            if (blocks.length === 0) return;

            const lastBlock = blocks[blocks.length - 1];
            const miners = ['miner1', 'miner2', 'miner3'];

            // Include all winners in the last block
            const lastWinners = miners
                .filter(miner => lastBlock.miners[miner] && lastBlock.miners[miner].success)
                .map(miner => ({
                    blockNumber: lastBlock.blockNumber,
                    miner,
                    hash: lastBlock.miners[miner].hash,
                    prevHash: lastBlock.miners[miner].prevHash
                }));

            // Add all last block winners to winnerChain
            winnerChain.push(...lastWinners);

            // Build a chain backward from one of the last winners
            if (lastWinners.length > 0) {
                let currentChain = [lastWinners[0]]; // Start with the first last winner
                let currentBlockIndex = blocks.length - 2;

                while (currentBlockIndex >= 0) {
                    const currentBlock = blocks[currentBlockIndex];
                    let found = false;

                    for (const miner of miners) {
                        if (currentBlock.miners[miner] && currentBlock.miners[miner].success &&
                            currentBlock.miners[miner].hash === currentChain[currentChain.length - 1].prevHash) {
                            currentChain.push({
                                blockNumber: currentBlock.blockNumber,
                                miner,
                                hash: currentBlock.miners[miner].hash,
                                prevHash: currentBlock.miners[miner].prevHash
                            });
                            found = true;
                            break;
                        }
                    }

                    if (!found) break;
                    currentBlockIndex--;
                }

                // If the chain reaches block 1001, add it to winnerChain
                if (currentChain.length === blocks.length && currentChain[currentChain.length - 1].prevHash === block1001Hash) {
                    winnerChain.push(...currentChain.slice(1).reverse()); // Add all but the first (already in lastWinners)
                }
            }

            console.log('Winner Chain:', winnerChain);
        }

        // Verify hash for a block
        function verifyHash(blockNum, miner, blockData) {
            const algo = document.querySelector('input[name="hashAlgo"]:checked').value;
            if (blockData.success) {
                const inputString = `${blockNum}${blockData.merkleRoot}${blockData.prevHash}${blockData.nonce}`;
                const computedHash = hash(inputString);
                const modalContent = document.getElementById('verifyContent');
                modalContent.textContent = `Verification for ${miner}, Block ${blockNum}\n\n` +
                                          `Input String Format: Block Number + Merkle Root + Previous Block + Nonce\n\n` +
                                          `Input String:\n${inputString}\n\n` +
                                          `Hash Algorithm: ${algo.toUpperCase()}\n\n` +
                                          `Computed Hash:\n${computedHash}\n\n` +
                                          `Expected Hash (from table):\n${blockData.hash}\n\n` +
                                          `Match: ${computedHash === blockData.hash ? 'Yes' : 'No'}`;
            } else {
                const modalContent = document.getElementById('verifyContent');
                modalContent.textContent = `Verification for ${miner}, Block ${blockNum}\n\n` +
                                          `This miner did not find a valid hash.\n` +
                                          `Lost Nonce: ${blockData.nonce}`;
            }
            document.getElementById('verifyModal').style.display = 'flex';
        }

        // Close modal
        function closeModal() {
            document.getElementById('verifyModal').style.display = 'none';
        }

        // Update fork table
        function updateForkTable() {
            const table = document.getElementById('forkTable');
            while (table.rows.length > 1) {
                table.deleteRow(1);
            }
            blocks.forEach(block => {
                const row = table.insertRow();
                const blockNumCell = row.insertCell();
                blockNumCell.textContent = block.blockNumber;
                ['miner1', 'miner2', 'miner3'].forEach(miner => {
                    const cell = row.insertCell();
                    cell.className = 'block-data';
                    const blockData = block.miners[miner];
                    if (blockData) {
                        if (blockData.success) {
                            cell.textContent = `Merkle Root: ${blockData.merkleRoot}\n` +
                                              `Previous Block: ${blockData.prevHash}\n` +
                                              `Nonce: ${blockData.nonce}\n` +
                                              `Block Hash: ${blockData.hash}`;
                            const verifyBtn = document.createElement('button');
                            verifyBtn.className = 'verify-btn';
                            verifyBtn.textContent = 'Verify Hash';
                            verifyBtn.onclick = () => verifyHash(block.blockNumber, miner, blockData);
                            cell.appendChild(document.createElement('br'));
                            cell.appendChild(verifyBtn);
                        } else {
                            cell.textContent = `Lost Nonce: ${blockData.nonce}`;
                            const verifyBtn = document.createElement('button');
                            verifyBtn.className = 'verify-btn';
                            verifyBtn.textContent = 'Verify';
                            verifyBtn.onclick = () => verifyHash(block.blockNumber, miner, blockData);
                            cell.appendChild(document.createElement('br'));
                            cell.appendChild(verifyBtn);
                        }
                        // Apply winner highlight if in winnerChain
                        if (winnerChain.some(w => w.blockNumber === block.blockNumber && w.miner === miner)) {
                            cell.classList.add('winner-highlight');
                        }
                        // Apply new block highlight
                        if (blockData.isNew) {
                            highlightChange(cell);
                            blockData.isNew = false;
                        }
                    }
                });
            });
        }

        // Reset simulation
        function resetSimulation() {
            console.log('Resetting simulation');
            simulationRunning = false;
            if (timeoutId) {
                clearTimeout(timeoutId);
                timeoutId = null;
            }
            blocks = [];
            winnerChain = []; // Reset winner chain
            currentBlockNumber = 1002;
            document.getElementById('difficulty').value = 4;
            document.getElementById('md5').checked = true;
            document.getElementById('calcBtn').disabled = false;
            document.getElementById('stopBtn').disabled = true;
            document.getElementById('resetBtn').disabled = false;
            document.getElementById('md5').disabled = false;
            document.getElementById('sha256').disabled = false;
            document.getElementById('difficulty').disabled = false;
            document.getElementById('winners').textContent = 'Winning Miners: None';
            updateBlock1001Hash();
            updateForkTable();
        }

        // Calculate block
        function calculateBlock() {
            console.log(`Starting calculation for fork block ${currentBlockNumber}`);
            try {
                const difficulty = parseInt(document.getElementById('difficulty').value) || 4;
                const nextBlock = {
                    blockNumber: currentBlockNumber,
                    miners: { miner1: null, miner2: null, miner3: null }
                };
                const miners = ['miner1', 'miner2', 'miner3'];
                let atLeastOneSuccess = false;
                const winners = [];

                let prevBlockHashes = [];
                if (blocks.length > 0) {
                    const prevBlock = blocks[blocks.length - 1];
                    miners.forEach(miner => {
                        if (prevBlock.miners[miner] && prevBlock.miners[miner].success) {
                            prevBlockHashes.push(prevBlock.miners[miner].hash);
                        }
                    });
                }
                if (prevBlockHashes.length === 0) {
                    prevBlockHashes.push(block1001Hash);
                }

                miners.forEach(miner => {
                    const merkleRoot = generateRandomHash(0, true);
                    let prevHash;
                    if (blocks.length > 0 && blocks[blocks.length - 1].miners[miner] && blocks[blocks.length - 1].miners[miner].success) {
                        prevHash = blocks[blocks.length - 1].miners[miner].hash;
                    } else {
                        prevHash = prevBlockHashes[Math.floor(Math.random() * prevBlockHashes.length)];
                    }
                    console.log(`Mining for ${miner}, block ${currentBlockNumber}, prevHash ${prevHash}`);
                    const result = mineBlock(merkleRoot, prevHash, difficulty, currentBlockNumber);
                    if (result.success && Math.random() > 0.3) {
                        nextBlock.miners[miner] = {
                            blockNumber: currentBlockNumber,
                            merkleRoot,
                            difficulty,
                            nonce: result.nonce,
                            hash: result.hash,
                            prevHash,
                            success: true,
                            isNew: true
                        };
                        atLeastOneSuccess = true;
                        winners.push(miner);
                        console.log(`${miner} succeeded for block ${currentBlockNumber}`);
                    } else {
                        nextBlock.miners[miner] = {
                            blockNumber: currentBlockNumber,
                            merkleRoot,
                            nonce: result.nonce,
                            success: false,
                            isNew: true
                        };
                        console.log(`${miner} failed for block ${currentBlockNumber}`);
                    }
                });

                if (!atLeastOneSuccess) {
                    const randomMiner = miners[Math.floor(Math.random() * miners.length)];
                    const merkleRoot = generateRandomHash(0, true);
                    let prevHash;
                    if (blocks.length > 0 && blocks[blocks.length - 1].miners[randomMiner] && blocks[blocks.length - 1].miners[miner].success) {
                        prevHash = blocks[blocks.length - 1].miners[randomMiner].hash;
                    } else {
                        prevHash = prevBlockHashes[Math.floor(Math.random() * prevBlockHashes.length)];
                    }
                    const result = mineBlock(merkleRoot, prevHash, difficulty, currentBlockNumber);
                    if (result.success) {
                        nextBlock.miners[randomMiner] = {
                            blockNumber: currentBlockNumber,
                            merkleRoot,
                            difficulty,
                            nonce: result.nonce,
                            hash: result.hash,
                            prevHash,
                            success: true,
                            isNew: true
                        };
                        winners.push(randomMiner);
                        console.log(`Forced success for ${randomMiner} on block ${currentBlockNumber}`);
                    } else {
                        nextBlock.miners[randomMiner] = {
                            blockNumber: currentBlockNumber,
                            merkleRoot,
                            nonce: result.nonce,
                            success: false,
                            isNew: true
                        };
                    }
                }

                blocks.push(nextBlock);
                updateForkTable();
                document.getElementById('winners').textContent = `Winning Miners for Block ${currentBlockNumber}: ${winners.length > 0 ? winners.join(', ') : 'None'}`;
                currentBlockNumber++;
            } catch (error) {
                console.error('Error in calculateBlock:', error);
                stopSimulation();
            }
        }

        // Start simulation
        function startSimulation() {
            if (simulationRunning) return;
            simulationRunning = true;
            document.getElementById('calcBtn').disabled = true;
            document.getElementById('stopBtn').disabled = false;
            document.getElementById('resetBtn').disabled = false;
            document.getElementById('md5').disabled = true;
            document.getElementById('sha256').disabled = false;
            document.getElementById('difficulty').disabled = true;
            runSimulation();
        }

        // Run simulation loop
        function runSimulation() {
            if (!simulationRunning) {
                console.log('Simulation stopped');
                return;
            }
            calculateBlock();
            timeoutId = setTimeout(runSimulation, 2000);
        }

        // Stop simulation
        function stopSimulation() {
            console.log('Stop simulation triggered');
            simulationRunning = false;
            if (timeoutId) {
                clearTimeout(timeoutId);
                timeoutId = null;
            }
            document.getElementById('calcBtn').disabled = false;
            document.getElementById('stopBtn').disabled = true;
            document.getElementById('resetBtn').disabled = false;
            document.getElementById('md5').disabled = false;
            document.getElementById('sha256').disabled = false;
            document.getElementById('difficulty').disabled = false;
            findWinnerChain();
            updateForkTable();
        }

        // Initialize
        window.onload = function() {
            updateBlock1001Hash();
            updateForkTable();
        };
    </script>

    <!-- Footer -->
    <!--#INCLUDE virtual="/inc_footer.asp"-->
</html>