<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Base58 Encoding and Decoding Tutorial</title>
    <meta name="description" content="A comprehensive guide to Base58 encoding and decoding, covering its use in cryptocurrencies, mathematical foundations, pseudo-code, Java and C# implementations, and handling BigInteger in C# with hex conversion.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

    <style>
        /* Default styles for light mode (when dark-mode class is not applied) */
        pre {
            background-color: #f5f5f5; /* Light grayish-white background for light mode */
            color: #333333; /* Dark gray text for contrast */
            padding: 15px;
            border-radius: 8px;
            overflow-x: auto;
            font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace;
            font-size: 0.9em;
        }
        pre code .keyword {
            color: #d32f2f; /* Darker pinkish-red for keywords in light mode */
        }
        pre code .string {
            color: #388e3c; /* Darker green for strings in light mode */
        }
        pre code .comment {
            color: #388e3c; /* Darker green for comments in light mode */
        }
    
        /* Override styles for dark mode (when dark-mode class is applied to body) */
        body.dark-mode pre {
            background-color: #1e2226; /* Dark gray background for dark mode */
            color: #d4d4d4; /* Light gray text for dark mode */
        }
        body.dark-mode pre code .keyword {
            color: #f44747; /* Pinkish-red for keywords in dark mode */
        }
        body.dark-mode pre code .string {
            color: #6a8759; /* Green for strings in dark mode */
        }
        body.dark-mode pre code .comment {
            color: #6a8759; /* Green for comments in dark mode */
        }

    </style>
</head>
<body class="dark-mode">
    <header>
        <h1>Base58 Encoding and Decoding Tutorial</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
        Tutorials /
        <a href="cryptography_blockchain_base58.asp">Cryptography, Blockchain, Base58</a>
    </section>

    <main>
        <!-- Introduction Section -->
        <section class="content-box">
            <h2>Introduction to Base58</h2>
            <p>Base58 is an encoding scheme used to represent large numbers as human-readable strings, primarily in cryptocurrency systems like Bitcoin and Ripple. It uses a 58-character alphabet (<code>123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz</code>), excluding ambiguous characters (<code>0</code>, <code>O</code>, <code>I</code>, <code>l</code>) to minimize errors in manual transcription. Unlike Base64, Base58 avoids non-alphanumeric characters (<code>+</code>, <code>/</code>), making it suitable for URLs, addresses, and user interfaces.</p>
            <p>Base58 is often used with a checksum (Base58Check) to ensure data integrity, as seen in Bitcoin addresses. This tutorial focuses on raw Base58 encoding and decoding for numeric values, useful for converting large integers to compact strings.</p>
            
            <div class="gray-box">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>Alphabet:</strong> 58 characters, designed for readability and error prevention.</li>
                    <li><strong>Base58Check:</strong> Adds a version byte and checksum for integrity (e.g., Bitcoin addresses).</li>
                    <li><strong>Use Cases:</strong> Cryptocurrency addresses, private keys, and compact number representation.</li>
                </ul>
            </div>
        </section>

        <!-- Mathematics and Pseudo-Code Section -->
        <section class="content-box">
            <h2>Mathematics and Pseudo-Code for Base58</h2>
            <p>Base58 encoding requires unsigned (non-negative) numbers as input, as it is designed to represent positive integers in contexts like cryptocurrency addresses. Negative numbers are invalid because the encoding process maps remainders to a 58-character alphabet, which assumes a positive value. Implementations typically enforce this by rejecting negative inputs, ensuring consistent and meaningful output.</p>
            <p>Base58 converts a large number into a base-58 representation, similar to how decimal uses base-10 or hexadecimal uses base-16. The process involves:</p>
            <ul>
                <li><strong>Encoding:</strong> Divide the number by 58, use remainders as indices into the Base58 alphabet, and build the string in reverse order.</li>
                <li><strong>Decoding:</strong> Map each character to its index (0–57), multiply the current value by 58, and add the index to compute the number.</li>
            </ul>
            
            <div class="gray-box">
                <h3>Mathematical Foundation</h3>
                <p>Let <code>N</code> be the input number (non-negative integer).</p>
                <p><strong>Encoding:</strong> Repeatedly compute <code>d = N mod 58</code>, append the character at index <code>d</code> in the alphabet, and update <code>N = N / 58</code>. Reverse the result to match big-endian order.</p>
                <p><strong>Decoding:</strong> For a string <code>S = c_1 c_2 ... c_n</code>, compute <code>N = sum(index(c_i) * 58^(n-i))</code>.</p>
            </div>
            <br>
            <div class="gray-box">
                <h3>Pseudo-Code: Encoding</h3>
                <pre>
<code>
FUNCTION encode_base58(number: BigInteger) -> String:
    IF number < 0 THEN ERROR "Input must be non-negative"
    alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    result = empty string
    WHILE number > 0:
        remainder = number % 58
        result = alphabet[remainder] + result
        number = number / 58
    RETURN result
END
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>Pseudo-Code: Decoding</h3>
                <pre>
<code>
FUNCTION decode_base58(base58: String) -> BigInteger:
    alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    value = 0
    FOR each character c in base58:
        index = position of c in alphabet
        IF index = -1 THEN ERROR "Invalid Base58 character"
        value = value * 58 + index
    RETURN value
END
</code>
                </pre>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    This handles raw Base58 for numeric values. For binary data, additional logic is needed for Base58Check or other formats.
                </div>
            </div>
        </section>

        <!-- Java Implementation Section -->
        <section class="content-box">
            <h2>Java Implementation</h2>
            <p>Below is a Java implementation for Base58 encoding and decoding, taking a <code>BigInteger</code> as input and returning a Base58 string.</p>

            <div class="gray-box">
                <h3>Base58 Encode/Decode</h3>
                <pre>
<code>
<span class="keyword">import</span> java.math.BigInteger;
<span class="keyword">import</span> java.util.Arrays;

<span class="keyword">public class</span> Base58 {
    <span class="comment">// Base58 alphabet</span>
    <span class="keyword">private static final</span> <span class="keyword">char</span>[] ALPHABET = <span class="string">"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"</span>.toCharArray();
    <span class="keyword">private static final</span> BigInteger BASE = BigInteger.valueOf(ALPHABET.length);
    <span class="keyword">private static final</span> <span class="keyword">int</span>[] INDEXES = <span class="keyword">new</span> <span class="keyword">int</span>[128];

    <span class="keyword">static</span> {
        Arrays.fill(INDEXES, -1);
        <span class="keyword">for</span> (<span class="keyword">int</span> i = 0; i < ALPHABET.length; i++) {
            INDEXES[ALPHABET[i]] = i;
        }
    }

    <span class="comment">// Encode a BigInteger to a Base58 string</span>
    <span class="keyword">public static</span> String encode(BigInteger value) {
        <span class="keyword">if</span> (value.compareTo(BigInteger.ZERO) < 0) {
            <span class="keyword">throw new</span> IllegalArgumentException(<span class="string">"Input must be non-negative"</span>);
        }
        StringBuilder sb = <span class="keyword">new</span> StringBuilder();
        <span class="keyword">while</span> (value.compareTo(BigInteger.ZERO) > 0) {
            BigInteger[] divmod = value.divideAndRemainder(BASE);
            sb.append(ALPHABET[divmod[1].intValue()]);
            value = divmod[0];
        }
        <span class="keyword">return</span> sb.length() > 0 ? sb.reverse().toString() : <span class="string">""</span>;
    }

    <span class="comment">// Decode a Base58 string to a BigInteger</span>
    <span class="keyword">public static</span> BigInteger decode(String input) {
        BigInteger value = BigInteger.ZERO;
        <span class="keyword">for</span> (<span class="keyword">char</span> c : input.toCharArray()) {
            <span class="keyword">int</span> index = INDEXES[c];
            <span class="keyword">if</span> (index == -1) {
                <span class="keyword">throw new</span> IllegalArgumentException(<span class="string">"Invalid Base58 character: "</span> + c);
            }
            value = value.multiply(BASE).add(BigInteger.valueOf(index));
        }
        <span class="keyword">return</span> value;
    }

    <span class="comment">// Example usage</span>
    <span class="keyword">public static void</span> main(String[] args) {
        BigInteger value = <span class="keyword">new</span> BigInteger(<span class="string">"123456"</span>);
        String encoded = encode(value);
        BigInteger decoded = decode(encoded);
        System.out.println(<span class="string">"Input: "</span> + value); // 123456
        System.out.println(<span class="string">"Base58: "</span> + encoded); // LDP
        System.out.println(<span class="string">"Decoded: "</span> + decoded); // 123456
    }
}
</code>
                </pre>
                <br>
                <div class="cyan-box">
                    <strong>Example Process: Encoding and Decoding 123456</strong><br>
                    <p><strong>Encoding (123456 to "LDP"):</strong></p>
                    <ol>
                        <li>Input: <code>N = 123456</code>.</li>
                        <li>Step 1: <code>123456 / 58 = 2128</code>, remainder <code>123456 mod 58 = 48</code>. ALPHABET[48] = <code>P</code>.</li>
                        <li>Step 2: <code>2128 / 58 = 36</code>, remainder <code>2128 mod 58 = 40</code>. ALPHABET[40] = <code>D</code>.</li>
                        <li>Step 3: <code>36 / 58 = 0</code>, remainder <code>36 mod 58 = 36</code>. ALPHABET[36] = <code>L</code>.</li>
                        <li>Stop: <code>N = 0</code>.</li>
                        <li>Result: <code>PDL</code>, reverse to <code>LDP</code>.</li>
                    </ol>
                    <p><strong>Decoding ("LDP" to 123456):</strong></p>
                    <ol>
                        <li>Input: <code>LDP</code>. Indices: <code>L</code>=36, <code>D</code>=40, <code>P</code>=48.</li>
                        <li>Step 1: <code>value = 0</code>.</li>
                        <li>Step 2: For <code>L</code>: <code>value = 0 * 58 + 36 = 36</code>.</li>
                        <li>Step 3: For <code>D</code>: <code>value = 36 * 58 + 40 = 2088 + 40 = 2128</code>.</li>
                        <li>Step 4: For <code>P</code>: <code>value = 2128 * 58 + 48 = 123424 + 48 = 123456</code>.</li>
                        <li>Result: <code>123456</code>.</li>
                    </ol>
                </div>
            </div>
        </section>

        <!-- C# Implementation Section -->
        <section class="content-box">
            <h2>C# Implementation</h2>
            <p>Below is a C# implementation for Base58 encoding and decoding, matching the Java version with <code>BigInteger</code> input and Base58 string output.</p>

            <div class="gray-box">
                <h3>Base58 Encode/Decode</h3>
                <pre>
<code>
<span class="keyword">using</span> System;
<span class="keyword">using</span> System.Numerics;
<span class="keyword">using</span> System.Text;

<span class="keyword">public class</span> Base58
{
    <span class="keyword">private const string</span> Base58Chars = <span class="string">"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"</span>;

    <span class="comment">// Encode a BigInteger to a Base58 string</span>
    <span class="keyword">public static string</span> Encode(BigInteger value)
    {
        <span class="keyword">if</span> (value < 0)
            <span class="keyword">throw new</span> ArgumentException(<span class="string">"Input must be non-negative"</span>);

        StringBuilder result = <span class="keyword">new</span> StringBuilder();
        <span class="keyword">while</span> (value > 0)
        {
            <span class="keyword">int</span> index = (<span class="keyword">int</span>)(value % 58);
            result.Insert(0, Base58Chars[index]);
            value /= 58;
        }
        <span class="keyword">return</span> result.ToString();
    }

    <span class="comment">// Decode a Base58 string to a BigInteger</span>
    <span class="keyword">public static</span> BigInteger Decode(<span class="keyword">string</span> base58)
    {
        BigInteger value = BigInteger.Zero;
        <span class="keyword">foreach</span> (<span class="keyword">char</span> c <span class="keyword">in</span> base58)
        {
            <span class="keyword">int</span> index = Base58Chars.IndexOf(c);
            <span class="keyword">if</span> (index == -1)
                <span class="keyword">throw new</span> ArgumentException(<span class="string">"Invalid Base58 character: "</span> + c);
            value = value * 58 + index;
        }
        <span class="keyword">return</span> value;
    }

    <span class="comment">// Example usage</span>
    <span class="keyword">public static void</span> Main()
    {
        BigInteger value = <span class="keyword">new</span> BigInteger(123456);
        <span class="keyword">string</span> encoded = Encode(value);
        BigInteger decoded = Decode(encoded);
        Console.WriteLine(<span class="string">$"Input: {value}"</span>); // 123456
        Console.WriteLine(<span class="string">$"Base58: {encoded}"</span>); // LDP
        Console.WriteLine(<span class="string">$"Decoded: {decoded}"</span>); // 123456
    }
}
</code>
                </pre>
                <br>
                <div class="cyan-box">
                    <strong>Example Process: Encoding and Decoding 123456</strong><br>
                    <p><strong>Encoding (123456 to "LDP"):</strong></p>
                    <ol>
                        <li>Input: <code>value = 123456</code>.</li>
                        <li>Step 1: <code>123456 mod 58 = 48</code>, <code>123456 / 58 = 2128</code>. Base58Chars[48] = <code>P</code>.</li>
                        <li>Step 2: <code>2128 mod 58 = 40</code>, <code>2128 / 58 = 36</code>. Base58Chars[40] = <code>D</code>.</li>
                        <li>Step 3: <code>36 mod 58 = 36</code>, <code>36 / 58 = 0</code>. Base58Chars[36] = <code>L</code>.</li>
                        <li>Stop: <code>value = 0</code>.</li>
                        <li>Result: Insert in reverse, yielding <code>LDP</code>.</li>
                    </ol>
                    <p><strong>Decoding ("LDP" to 123456):</strong></p>
                    <ol>
                        <li>Input: <code>LDP</code>. Indices: <code>L</code>=36, <code>D</code>=40, <code>P</code>=48.</li>
                        <li>Step 1: <code>value = 0</code>.</li>
                        <li>Step 2: For <code>L</code>: <code>value = 0 * 58 + 36 = 36</code>.</li>
                        <li>Step 3: For <code>D</code>: <code>value = 36 * 58 + 40 = 2088 + 40 = 2128</code>.</li>
                        <li>Step 4: For <code>P</code>: <code>value = 2128 * 58 + 48 = 123424 + 48 = 123456</code>.</li>
                        <li>Result: <code>123456</code>.</li>
                    </ol>
                </div>
            </div>
        </section>

        <!-- Hex to BigInteger Section -->
        <section class="content-box">
            <h2>Converting Hex to BigInteger in C#</h2>
            <p>When preparing data for Base58 encoding in C#, you may need to convert a hex string to a <code>BigInteger</code>. This requires careful handling due to <code>BigInteger</code>’s two’s-complement interpretation.</p>
            
            <div class="gray-box">
                <h3>Logic and Behavior</h3>
                <p><strong>Hex to Bytes:</strong> Convert the hex string to a byte array (e.g., <code>"1E240"</code> → <code>{ 0x1E, 0x24, 0x0 }</code>).</p>
                <p><strong>BigInteger Constructor:</strong> Interprets the byte array as a little-endian two’s-complement number:</p>
                <ul>
                    <li>If the first byte ≥ <code>0x80</code> (e.g., <code>0xFF</code>), it’s negative unless a <code>0</code> byte is appended.</li>
                    <li>Example: <code>{ 0xFF }</code> → <code>-1</code> (negative) without <code>0</code>, <code>255</code> (positive) with <code>0</code>.</li>
                </ul>
                <p><strong>Ensuring Positive:</strong> Append a <code>0</code> byte to guarantee a positive <code>BigInteger</code>:</p>
                <pre>
<code>
BigInteger value = new BigInteger(data.Concat(new byte[] { 0 }).ToArray());
</code>
                </pre>
                <p><strong>Why Always Add 0?</strong> It’s simpler than checking <code>data[0] >= 0x80</code>, covers all cases (empty arrays, all byte values), and aligns with Base58’s unsigned number requirement. The overhead is negligible.</p>
                <br>
                <p><strong>Example Conversion:</strong></p>
                <pre>
<code>
<span class="keyword">public static</span> BigInteger HexToBigInteger(<span class="keyword">string</span> hex)
{
    <span class="keyword">byte</span>[] data = FromHexString(hex);
    <span class="keyword">return new</span> BigInteger(data.Concat(<span class="keyword">new byte</span>[] { 0 }).ToArray()); <span class="comment">// Ensure positive</span>
}

<span class="keyword">private static byte</span>[] FromHexString(<span class="keyword">string</span> hex)
{
    <span class="keyword">if</span> (string.IsNullOrEmpty(hex))
        <span class="keyword">throw new</span> ArgumentException(<span class="string">"Hex string cannot be null or empty."</span>);

    hex = hex.Trim();
    <span class="keyword">if</span> (hex.Length % 2 != 0)
        <span class="keyword">throw new</span> ArgumentException(<span class="string">$"Hex string length must be even, got {hex.Length} characters."</span>);

    <span class="keyword">var</span> numberChars = hex.Length;
    <span class="keyword">var</span> hexAsBytes = <span class="keyword">new byte</span>[numberChars / 2];
    <span class="keyword">for</span> (<span class="keyword">var</span> i = 0; i < numberChars; i += 2)
        hexAsBytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);

    <span class="keyword">return</span> hexAsBytes;
}
</code>
                </pre>
                <p><strong>Usage:</strong></p>
                <pre>
<code>
<span class="keyword">string</span> hex = <span class="string">"1E240"</span>; <span class="comment">// 123456 in decimal</span>
BigInteger value = HexToBigInteger(hex); <span class="comment">// 123456</span>
<span class="keyword">string</span> base58 = Base58.Encode(value); <span class="comment">// LDP</span>
</code>
                </pre>
                <br>
                <div class="cyan-box">
                    <strong>Example Process: Hex to BigInteger ("1E240" to 123456)</strong><br>
                    <p><strong>Conversion:</strong></p>
                    <ol>
                        <li>Input: Hex string <code>1E240</code>.</li>
                        <li>Step 1: Parse hex to bytes:
                            <ul>
                                <li><code>1E</code> → <code>0x1E</code> (30).</li>
                                <li><code>24</code> → <code>0x24</code> (36).</li>
                                <li><code>0</code> → <code>0x00</code> (0).</li>
                                <li>Result: <code>{ 0x1E, 0x24, 0x00 }</code>.</li>
                            </ul>
                        </li>
                        <li>Step 2: Append <code>0</code> byte to ensure positive: <code>{ 0x1E, 0x24, 0x00, 0x00 }</code>.</li>
                        <li>Step 3: Create BigInteger (little-endian):
                            <ul>
                                <li>Interpret as big-endian hex <code>1E240</code>.</li>
                                <li>Compute: <code>30 * 256^2 + 36 * 256^1 + 0 * 256^0 = 1966080 + 9216 + 0 = 123456</code>.</li>
                            </ul>
                        </li>
                        <li>Result: <code>BigInteger = 123456</code>.</li>
                    </ol>
                </div>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    Appending a <code>0</code> byte ensures compatibility with Java’s positive <code>BigInteger</code> and Base58’s unsigned number requirement.
                </div>
            </div>
        </section>

        <!-- Additional Resources -->
        <section class="content-box">
            <h2>Additional Resources</h2>
            
            <div class="gray-box">
                <h3>Reference Implementations</h3>
                <ul>
                    <li><a href="https://en.bitcoin.it/wiki/Base58Check_encoding" target="_blank">Bitcoin Wiki: Base58Check Encoding</a></li>
                    <li><a href="https://xrpl.org/base58-encodings.html" target="_blank">Ripple Base58 Documentation</a></li>
                    <li><a href="https://docs.oracle.com/javase/8/docs/api/java/math/BigInteger.html" target="_blank">Java BigInteger Documentation</a></li>
                    <li><a href="https://learn.microsoft.com/en-us/dotnet/api/system.numerics.biginteger" target="_blank">C# BigInteger Documentation</a></li>
                </ul>
            </div>
            <br>
            <div class="gray-box">
                <h3>Further Reading</h3>
                <ul>
                    <li><a href="https://stackoverflow.com/questions/4195407/how-to-encode-decode-base58" target="_blank">Stack Overflow: Base58 Encoding</a></li>
                    <li><a href="https://crypto.stackexchange.com/questions/75788/what-is-base58check-encoding" target="_blank">Cryptography Stack Exchange: Base58 in Cryptocurrencies</a></li>
                    <li><a href="https://en.wikipedia.org/wiki/Base58" target="_blank">Wikipedia: Base58</a></li>
                </ul>
            </div>
        </section>


        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its assistance in developing this tutorial on Base58 encoding and decoding.</p>
        </section>
    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->
</html>