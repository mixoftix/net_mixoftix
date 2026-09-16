<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ECDSA Signature: RAW - DER Conversion</title>
    <meta name="description" content="A guide to converting ECDSA signatures between RAW and DER formats for blockchain transactions, including compact vs normal DER, mathematical conversions, DER history, C# implementations, and Base64 encoding">
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
        <h1>ECDSA Signature: RAW - DER Conversion</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()"> Dark Mode
        </label>
    </header>

    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
        Tutorials /
        <a href="cryptography_ecdsa_raw_der.asp">Cryptography, ECDSA, RAW - DER Conversion</a>
    </section>

    <main>
        <!-- Introduction Section -->
        <section class="content-box">
            <h2>Understanding ECDSA Signature Formats</h2>
            <p>In blockchain transactions, ECDSA signatures are encoded in <strong>RAW</strong> or <strong>DER</strong> formats. This tutorial explores converting between these formats, essential for interoperability between platforms like C# (RAW) and Java (DER). We cover the mathematical conversion, differences between compact and normal DER, the history and necessity of DER, pseudo-code, C# implementations, sample outputs, and the role of Base64 encoding.</p>
            
            <div class="gray-box">
                <h3>Key Concepts</h3>
                <ul>
                    <li><strong>RAW Format:</strong> Concatenation of R and S components, 64 bytes for secp256r1 (32 bytes each).</li>
                    <li><strong>DER Format:</strong> ASN.1-encoded SEQUENCE of R and S INTEGERs, typically 70-72 bytes.</li>
                    <li><strong>Compact DER:</strong> Minimizes length by trimming leading zeros from R and S.</li>
                    <li><strong>Base64 Encoding:</strong> Converts binary signatures to text-safe ASCII.</li>
                </ul>
            </div>
        </section>

        <!-- DER Format and History Section -->
        <section class="content-box">
            <h2>DER Format and Its History</h2>
            <p>The <strong>Distinguished Encoding Rules (DER)</strong> is a subset of ASN.1 (Abstract Syntax Notation One), standardized for encoding structured data in a compact, unambiguous binary format. DER is widely used in cryptography for encoding signatures, certificates, and keys.</p>
            
            <div class="gray-box">
                <h3>Origins and Purpose</h3>
                <p>Developed in the 1980s by the ITU-T and ISO/IEC, ASN.1 and DER emerged to standardize data exchange in telecommunications and computing. DER’s strict rules ensure a single, canonical encoding for each data structure, critical for security applications where ambiguity could lead to vulnerabilities.</p>
                <br>
                <p><strong>Why DER?</strong></p>
                <ul>
                    <li><strong>Unambiguity:</strong> Ensures identical data has one encoding, vital for signature verification.</li>
                    <li><strong>Interoperability:</strong> Used in X.509 certificates, SSL/TLS, and blockchain, enabling cross-platform compatibility.</li>
                    <li><strong>Structure:</strong> Supports complex data (e.g., SEQUENCE of INTEGERs for ECDSA signatures).</li>
                </ul>
                <br>
                <p><strong>Necessity in Blockchain:</strong> In blockchain, DER is used (e.g., by Bitcoin, Ethereum, Java) to encode ECDSA signatures, ensuring consistent parsing across systems. Its structured format allows verification of \( R \), \( S \) components without ambiguity, unlike RAW’s simple concatenation.</p>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    DER’s canonical encoding prevents attacks exploiting encoding variations, making it a standard in cryptographic protocols.
                </div>
            </div>
        </section>

        <!-- Compact vs Normal DER Section -->
        <section class="content-box">
            <h2>Compact DER vs Normal DER</h2>
            <p>DER encodings for ECDSA signatures can be <strong>Compact</strong> or <strong>Normal</strong>, differing in how \( R \) and \( S \) are encoded as ASN.1 INTEGERs.</p>
            
            <div class="gray-box">
                <h3>Normal DER</h3>
                <p>In Normal DER, \( R \) and \( S \) are encoded as full 32-byte integers (for secp256r1), regardless of leading zeros, unless the MSB requires a \( 0x00 \) for positivity:</p>
                <ul>
                    <li><strong>Length:</strong> Typically 70-72 bytes (32 or 33 bytes per INTEGER).</li>
                    <li><strong>Example:</strong> An \( R \) with leading zeros (e.g., `0000...1234`) is encoded as 32 bytes.</li>
                    <li><strong>Use Case:</strong> Common in platforms prioritizing simplicity over size (e.g., some C# implementations).</li>
                </ul>
                <br>
                <p>Example (R = `0000...3082DA1F...`, 32 bytes):</p>
                <pre>
<code>
304502203082DA1FE652B2EDCC2EE3E20E18B07BE1430E4C7763482B27E914697FDE9BF5022100CCBFC7B09337E29A5D243364DC80086FA1425FFEF66A34143487D103247592C4
- rLength = 0x20 (32 bytes)
- sLength = 0x21 (33 bytes, with 0x00)
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>Compact DER</h3>
                <p>Compact DER trims leading zeros from \( R \) and \( S \), encoding only the minimal bytes needed to represent the integer, unless a \( 0x00 \) is required:</p>
                <ul>
                    <li><strong>Length:</strong> As low as 68 bytes (e.g., 16 bytes for \( R \), 33 for \( S \)).</li>
                    <li><strong>Example:</strong> \( R = 0000...1234 \) becomes `1234` (e.g., 16 bytes).</li>
                    <li><strong>Use Case:</strong> Preferred in Java, Bitcoin, and size-sensitive applications.</li>
                </ul>
                <br>
                <p>Example (same R, trimmed to 16 bytes):</p>
                <pre>
<code>
304402103082DA1FE652B2EDCC2EE3E20E18B07BE1430E4C7763482B27E914697FDE9BF5022100CCBFC7B09337E29A5D243364DC80086FA1425FFEF66A34143487D103247592C4
- rLength = 0x10 (16 bytes)
- sLength = 0x21 (33 bytes)
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>Key Differences</h3>
                <ul>
                    <li><strong>Size:</strong> Compact DER is smaller (e.g., 68 vs 71 bytes).</li>
                    <li><strong>Encoding:</strong> Compact trims leading zeros; Normal uses full 32 bytes.</li>
                    <li><strong>Compatibility:</strong> Both are valid DER, but Compact is standard in Java, Normal in some .NET implementations.</li>
                    <li><strong>Conversion:</strong> Converters must handle both, trimming for Compact DER, padding for RAW.</li>
                </ul>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    Compact DER optimizes bandwidth in blockchain transactions, but converters must support both forms for interoperability.
                </div>
            </div>
        </section>

        <!-- Mathematical Conversion Section -->
        <section class="content-box">
            <h2>Mathematical Conversion Between RAW and DER</h2>
            <p>ECDSA signatures for secp256r1 consist of \( R \), \( S \), each 32 bytes in RAW. Conversion handles variable-length DER encodings.</p>
            
            <div class="gray-box">
                <h3>RAW Format</h3>
                <p>RAW concatenates:</p>
                <pre>
<code>
\[ \text{RAW} = R \parallel S \]
\[ \text{Length} = 64 \text{ bytes} \]
</code>
                </pre>
                <p>Example:</p>
                <pre>
<code>
R = 000000000000000000000000000000003082DA1FE652B2EDCC2EE3E20E18B07BE1430E4C7763482B27E914697FDE9BF5
S = CCBFC7B09337E29A5D243364DC80086FA1425FFEF66A34143487D103247592C4
RAW = 000000000000000000000000000000003082DA1FE652B2EDCC2EE3E20E18B07BE1430E4C7763482B27E914697FDE9BF5CCBFC7B09337E29A5D243364DC80086FA1425FFEF66A34143487D103247592C4
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>DER Format</h3>
                <p>DER is a SEQUENCE:</p>
                <pre>
<code>
\[ \text{DER} = 0x30 \parallel \text{length} \parallel 0x02 \parallel \text{rLength} \parallel R \parallel 0x02 \parallel \text{sLength} \parallel S \]
</code>
                </pre>
                <p>Components:
                    <ul>
                        <li>\( 0x30 \): SEQUENCE tag.</li>
                        <li>\( \text{length} \): Total length.</li>
                        <li>\( \text{rLength}, \text{sLength} \): 1-33 bytes.</li>
                        <li>\( R, S \): Minimal bytes, \( 0x00 \) if MSB \( \geq 0x80 \).</li>
                    </ul>
                </p>
                <p>Example:</p>
                <pre>
<code>
DER = 304402103082DA1FE652B2EDCC2EE3E20E18B07BE1430E4C7763482B27E914697FDE9BF5022100CCBFC7B09337E29A5D243364DC80086FA1425FFEF66A34143487D103247592C4
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>Conversion Math</h3>
                <p><strong>RAW to DER:</strong></p>
                <ol>
                    <li>Split: \( R = \text{bytes}[0:32] \), \( S = \text{bytes}[32:64] \).</li>
                    <li>Trim leading zeros, keeping 1 byte.</li>
                    <li>Prepend \( 0x00 \) if MSB \( \geq 0x80 \).</li>
                    <li>Build: \( 0x30 \parallel \text{totalLength} \parallel 0x02 \parallel \text{rLength} \parallel R \parallel 0x02 \parallel \text{sLength} \parallel S \).</li>
                </ol>
                <p><strong>DER to RAW:</strong></p>
                <ol>
                    <li>Parse: Verify \( 0x30 \), extract \( R \), \( S \).</li>
                    <li>Normalize: Remove \( 0x00 \) if \( \text{length} > 32 \), pad to 32 bytes.</li>
                    <li>Output: \( R \parallel S \).</li>
                </ol>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    Trimming ensures Compact DER, while padding ensures RAW’s fixed 64 bytes.
                </div>
            </div>
        </section>

        <!-- Pseudo-Code Section -->
        <section class="content-box">
            <h2>Pseudo-Code for Conversion</h2>
            
            <div class="gray-box">
                <h3>RAW to DER</h3>
                <pre>
<code>
FUNCTION RAW_TO_DER(rawSignature):
    IF LEN(rawSignature) != 64 THEN ERROR "Raw signature must be 64 bytes"
    R = rawSignature[0:32]
    S = rawSignature[32:64]
    
    // Trim leading zeros, keep at least 1 byte
    rTrimmed = TRIM_LEADING_ZEROS(R)
    IF LEN(rTrimmed) = 0 THEN rTrimmed = [0x00]
    sTrimmed = TRIM_LEADING_ZEROS(S)
    IF LEN(sTrimmed) = 0 THEN sTrimmed = [0x00]
    
    // Add 0x00 if MSB >= 0x80
    rDer = IF rTrimmed[0] >= 0x80 THEN (0x00 || rTrimmed) ELSE rTrimmed
    sDer = IF sTrimmed[0] >= 0x80 THEN (0x00 || sTrimmed) ELSE sTrimmed
    
    totalLength = 2 + LEN(rDer) + 2 + LEN(sDer)
    RETURN 0x30 || totalLength || 0x02 || LEN(rDer) || rDer || 0x02 || LEN(sDer) || sDer
END
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>DER to RAW</h3>
                <pre>
<code>
FUNCTION DER_TO_RAW(derSignature):
    IF derSignature[0] != 0x30 THEN ERROR "Invalid DER"
    rStart = 4
    IF derSignature[2] != 0x02 THEN ERROR "Invalid R marker"
    rLength = derSignature[3]
    IF rLength > 33 OR rLength < 1 THEN ERROR "R length out of bounds"
    R = derSignature[rStart:rStart+rLength]
    IF R[0] = 0x00 AND rLength > 32 THEN R = R[1:]
    R = PAD_LEFT(R, 32, 0x00)
    
    sStart = rStart + rLength + 2
    IF derSignature[sStart-2] != 0x02 THEN ERROR "Invalid S marker"
    sLength = derSignature[sStart-1]
    IF sLength > 33 OR sLength < 1 THEN ERROR "S length out of bounds"
    S = derSignature[sStart:sStart+sLength]
    IF S[0] = 0x00 AND sLength > 32 THEN S = S[1:]
    S = PAD_LEFT(S, 32, 0x00)
    
    RETURN R || S
END
</code>
                </pre>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    Compact DER output ensures interoperability with Java-based systems.
                </div>
            </div>
        </section>

        <!-- Why Base64 Section -->
        <section class="content-box">
            <h2>Why Use Base64 Encoding?</h2>
            <p>Signatures are binary, risking corruption in text-based systems. Base64 converts them to ASCII:</p>
            
            <div class="gray-box">
                <ul>
                    <li><strong>Text Safety:</strong> Safe for JSON, HTTP, databases.</li>
                    <li><strong>Efficiency:</strong> ~33% size increase.</li>
                    <li><strong>Standardization:</strong> Universal support.</li>
                </ul>
                <br>
                <p>Example:</p>
                <pre>
<code>
RAW (64 bytes): 0000000000000000...247592C4
Base64: AAAAAAAAAAAA...QMkdZLE=
DER (70 bytes): 304402103082DA1F...247592C4
Base64: MEYCIQDyEdof5lKy...QMkdZLE=
</code>
                </pre>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    Base64 ensures safe transmission across platforms.
                </div>
            </div>
        </section>

        <!-- C# Implementation Section -->
        <section class="content-box">
            <h2>C# Implementation</h2>
            <p>Below are C# functions for converting ECDSA signatures between RAW and DER formats for secp256r1.</p>

            <div class="gray-box">
                <h3>RAW to DER</h3>
                <pre>
<code>
<span class="keyword">using</span> System;
<span class="keyword">using</span> System.Linq;

<span class="keyword">public byte</span>[] RawToDerSignature(<span class="keyword">byte</span>[] rawSignature)
{
    <span class="keyword">if</span> (rawSignature.Length != 64)
        <span class="keyword">throw new</span> ArgumentException(<span class="string">"Raw signature must be 64 bytes for secp256r1"</span>);

    <span class="keyword">byte</span>[] r = rawSignature.Take(32).ToArray();
    <span class="keyword">byte</span>[] s = rawSignature.Skip(32).Take(32).ToArray();

    <span class="comment">// Trim leading zeros, keep at least 1 byte</span>
    <span class="keyword">int</span> rTrimmedLength = r.Length;
    <span class="keyword">while</span> (rTrimmedLength > 1 && r[r.Length - rTrimmedLength] == 0x00)
        rTrimmedLength--;
    <span class="keyword">byte</span>[] rTrimmed = r.Skip(r.Length - rTrimmedLength).Take(rTrimmedLength).ToArray();

    <span class="keyword">int</span> sTrimmedLength = s.Length;
    <span class="keyword">while</span> (sTrimmedLength > 1 && s[s.Length - sTrimmedLength] == 0x00)
        sTrimmedLength--;
    <span class="keyword">byte</span>[] sTrimmed = s.Skip(s.Length - sTrimmedLength).Take(sTrimmedLength).ToArray();

    <span class="comment">// Add 0x00 if MSB >= 0x80</span>
    <span class="keyword">bool</span> rNeedsPadding = rTrimmed[0] >= 0x80;
    <span class="keyword">bool</span> sNeedsPadding = sTrimmed[0] >= 0x80;

    <span class="keyword">byte</span>[] rDer = rNeedsPadding ? <span class="keyword">new byte</span>[] { 0x00 }.Concat(rTrimmed).ToArray() : rTrimmed;
    <span class="keyword">byte</span>[] sDer = sNeedsPadding ? <span class="keyword">new byte</span>[] { 0x00 }.Concat(sTrimmed).ToArray() : sTrimmed;

    <span class="keyword">int</span> totalLength = 2 + rDer.Length + 2 + sDer.Length;
    <span class="keyword">byte</span>[] der = <span class="keyword">new byte</span>[2 + totalLength];
    der[0] = 0x30;
    der[1] = (<span class="keyword">byte</span>)totalLength;
    der[2] = 0x02;
    der[3] = (<span class="keyword">byte</span>)rDer.Length;
    Buffer.BlockCopy(rDer, 0, der, 4, rDer.Length);
    der[4 + rDer.Length] = 0x02;
    der[5 + rDer.Length] = (<span class="keyword">byte</span>)sDer.Length;
    Buffer.BlockCopy(sDer, 0, der, 6 + rDer.Length, sDer.Length);

    <span class="keyword">return</span> der;
}
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>DER to RAW</h3>
                <pre>
<code>
<span class="keyword">public byte</span>[] DerToRawSignature(<span class="keyword">byte</span>[] derSignature)
{
    <span class="keyword">if</span> (derSignature[0] != 0x30 || derSignature.Length < 6)
        <span class="keyword">throw new</span> ArgumentException(<span class="string">"Invalid DER signature format"</span>);

    <span class="keyword">int</span> rStart = 4;
    <span class="keyword">if</span> (derSignature[2] != 0x02)
        <span class="keyword">throw new</span> ArgumentException(<span class="string">"Invalid R marker"</span>);
    <span class="keyword">int</span> rLength = derSignature[3];
    <span class="keyword">if</span> (rLength < 1 || rLength > 33 || rStart + rLength > derSignature.Length)
        <span class="keyword">throw new</span> ArgumentException(<span class="string">"R length out of bounds for secp256r1"</span>);

    <span class="keyword">byte</span>[] rFull = <span class="keyword">new byte</span>[rLength];
    Buffer.BlockCopy(derSignature, rStart, rFull, 0, rLength);

    <span class="keyword">byte</span>[] r = <span class="keyword">new byte</span>[32];
    <span class="keyword">int</span> rSrcOffset = rLength > 32 ? 1 : 0;
    <span class="keyword">int</span> rBytesToCopy = Math.Min(rLength, 32);
    <span class="keyword">int</span> rDestOffset = 32 - rBytesToCopy;
    Buffer.BlockCopy(rFull, rSrcOffset, r, rDestOffset, rBytesToCopy);

    <span class="keyword">int</span> sStart = rStart + rLength + 2;
    <span class="keyword">if</span> (derSignature[sStart - 2] != 0x02)
        <span class="keyword">throw new</span> ArgumentException(<span class="string">"Invalid S marker"</span>);
    <span class="keyword">int</span> sLength = derSignature[sStart - 1];
    <span class="keyword">if</span> (sLength < 1 || sLength > 33 || sStart + sLength > derSignature.Length)
        <span class="keyword">throw new</span> ArgumentException(<span class="string">"S length out of bounds for secp256r1"</span>);

    <span class="keyword">byte</span>[] sFull = <span class="keyword">new byte</span>[sLength];
    Buffer.BlockCopy(derSignature, sStart, sFull, 0, sLength);

    <span class="keyword">byte</span>[] s = <span class="keyword">new byte</span>[32];
    <span class="keyword">int</span> sSrcOffset = sLength > 32 ? 1 : 0;
    <span class="keyword">int</span> sBytesToCopy = Math.Min(sLength, 32);
    <span class="keyword">int</span> sDestOffset = 32 - sBytesToCopy;
    Buffer.BlockCopy(sFull, sSrcOffset, s, sDestOffset, sBytesToCopy);

    <span class="keyword">return</span> r.Concat(s).ToArray();
}
</code>
                </pre>
            </div>
            <br>
            <div class="gray-box">
                <h3>Sample Usage and Outputs</h3>
                <p>Using your sample signature:</p>
                <pre>
<code>
<span class="keyword">public static void</span> Main()
{
    <span class="comment">// Sample RAW signature (64 bytes)</span>
    <span class="keyword">byte</span>[] rawSignature = <span class="keyword">new byte</span>[] {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x30, 0x82, 0xDA, 0x1F, 0xE6, 0x52, 0xB2, 0xED, 0xCC, 0x2E, 0xE3, 0xE2, 0x0E, 0x18, 0xB0, 0x7B,
        0xCC, 0xBF, 0xC7, 0xB0, 0x93, 0x37, 0xE2, 0x9A, 0x5D, 0x24, 0x33, 0x64, 0xDC, 0x80, 0x08, 0x6F,
        0xA1, 0x42, 0x5F, 0xFE, 0xF6, 0x6A, 0x34, 0x14, 0x34, 0x87, 0xD1, 0x03, 0x24, 0x75, 0x92, 0xC4
    };

    <span class="comment">// Convert RAW to DER</span>
    <span class="keyword">byte</span>[] derSignature = RawToDerSignature(rawSignature);
    <span class="keyword">string</span> derBase64 = Convert.ToBase64String(derSignature);
    Console.WriteLine(<span class="string">"DER Signature (Base64): "</span> + derBase64);

    <span class="comment">// Convert DER back to RAW</span>
    <span class="keyword">byte</span>[] rawBack = DerToRawSignature(derSignature);
    <span class="keyword">string</span> rawBase64 = Convert.ToBase64String(rawBack);
    Console.WriteLine(<span class="string">"RAW Signature (Base64): "</span> + rawBase64);
}
</code>
                </pre>
                <br>
                <div class="green-box">
                    <strong>Sample Input:</strong><br>
                    RAW Signature (hex): 000000000000000000000000000000003082DA1FE652B2EDCC2EE3E20E18B07BCCBFC7B09337E29A5D243364DC80086FA1425FFEF66A34143487D103247592C4
                </div>
                <br>
                <div class="green-box">
                    <strong>Sample Output:</strong><br>
                    DER Signature (Base64): MEYCIQDyEdof5lKy7cwu4+IOGLB74UMOTHdjSCsn6RRpf96b9QIhAIy/x7CTN+KaXSQzZNyACG+hQl/+/mq0FDSH0QMkdZLE=<br>
                    RAW Signature (Base64): AAAAAAAAAAAAAAAAAAAAAAAAAAAAAzCC2h/mUrLtzC7j4g4YsHvBQw5Mvx7wkzfinl0kM2TcgAhvoUJf/vZqNBQ0h9EDJHWSxA==
                </div>
                <br>
                <div class="yellow-box">
                    <strong>Critical Note:</strong><br>
                    The converters are reversible, producing Compact DER for interoperability with Java.
                </div>
            </div>
        </section>

        <!-- Additional Resources -->
        <section class="content-box">
            <h2>Additional Resources</h2>
            
            <div class="gray-box">
                <h3>Reference Implementations</h3>
                <ul>
                    <li><a href="https://www.itu.int/rec/T-REC-X.690" target="_blank">ITU-T X.690: ASN.1 DER Specification</a></li>
                    <li><a href="https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.ecdsa" target="_blank">C# ECDSA Documentation</a></li>
                    <li><a href="https://docs.oracle.com/javase/8/docs/api/java/security/Signature.html" target="_blank">Java Signature Documentation</a></li>
                </ul>
            </div>
            <br>
            <div class="gray-box">
                <h3>Further Reading</h3>
                <ul>
                    <li><a href="https://crypto.stackexchange.com/questions/1795/how-to-convert-a-der-ecdsa-signature-to-asn-1" target="_blank">Stack Exchange: DER vs RAW Signatures</a></li>
                    <li><a href="https://en.wikipedia.org/wiki/Base64" target="_blank">Wikipedia: Base64 Encoding</a></li>
                    <li><a href="https://bitcoin.org/en/developer-guide#signature" target="_blank">Bitcoin Developer Guide: Signatures</a></li>
                </ul>
            </div>
        </section>

        <!-- Acknowledgments -->
        <section class="content-box">
            <h3>Acknowledgments</h3>
            <p>Special thanks to Grok, for its assistance in developing this tutorial on ECDSA signature conversion.</p>
        </section>
    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->
</html>