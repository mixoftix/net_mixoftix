<style>

/* Base styles */
body {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 20px auto;
    padding: 20px;
    transition: background-color 0.3s, color 0.3s;
    text-align: center;
    background-color: #1a1a1a;
    color: #f0f0f0;
}

h1 {
    color: #ffffff;
    margin-bottom: 10px;
}

h2, h3 {
    color: #ffffff;
    margin-bottom: 10px;
}

/* Table Styling (Shared Properties) */
table {
    border-collapse: collapse;
    width: 100%;
    margin: 10px 0;
    font-size: 14px;
}

table th, table td {
    padding: 8px;
    text-align: left;
    border: 1px solid #666; /* Border for dark mode */
    color: #f0f0f0; /* Text color for dark mode */
}

table th {
    background-color: #333; /* Darker background for headers in dark mode */
}

table td {
    background-color: #222; /* Background for cells in dark mode */
}

table hr {
    border: 0;
    border-top: 1px solid #666; /* Horizontal rule for dark mode */
}

/* Light Mode Table Styling */
.light-mode table th, .light-mode table td {
    border: 1px solid #999; /* Border for light mode */
    color: #333; /* Text color for light mode */
}

.light-mode table th {
    background-color: #ddd; /* Lighter background for headers in light mode */
}

.light-mode table td {
    background-color: #f5f5f5; /* Background for cells in light mode */
}

.light-mode table hr {
    border-top: 1px solid #999; /* Horizontal rule for light mode */
}

/* Navigation Bar */
.content-box {
    margin-top: 20px;
    padding: 15px;
    border: 2px solid #666;
    border-radius: 8px;
    background-color: #222;
    text-align: left;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.content-box a {
    color: #44ffff; /* Cyan in dark mode */
    text-decoration: underline;
    cursor: pointer;
}

.content-box a:hover {
    color: #00cccc; /* Darker cyan on hover in dark mode */
}

/* Colored Boxes */
.colored-boxes {
    margin-top: 20px;
    display: grid;
    gap: 20px;
}

.gray-box {
    padding: 15px;
    background-color: #2c2c2c;
    border: 1px solid #444;
    border-radius: 5px;
    text-align: left;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.gray-box pre {
    margin: 0;
    padding: 10px;
    border: 1px solid #666; /* Frame for code block */
    border-radius: 3px;
    background-color: #1e1e1e; /* Slightly darker background for code */
    font-family: 'Courier New', Courier, monospace;
    font-size: 14px;
    white-space: pre; /* Preserve indentation */
    overflow-x: auto; /* Horizontal scroll if needed */
}

.yellow-box {
    padding: 15px;
    background-color: #4a4a2c;
    border: 1px solid #ffff44;
    border-radius: 5px;
    text-align: left;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.cyan-box {
    padding: 15px;
    background-color: #2c4a4a;
    border: 1px solid #44ffff;
    border-radius: 5px;
    text-align: left;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.red-box {
    padding: 15px;
    background-color: #4a2c2c;
    border: 1px solid #ff4444;
    border-radius: 5px;
    text-align: left;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.green-box {
    padding: 15px;
    background-color: #2c4a2c;
    border: 1px solid #44ff44;
    border-radius: 5px;
    text-align: left;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

/* Light Mode */
.light-mode {
    background-color: #ffffff;
    color: #333;
}

.light-mode h1,
.light-mode h2,
.light-mode h3 {
    color: #333;
}

.light-mode .content-box {
    border-color: #999;
    background-color: #f5f5f5;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.light-mode .content-box a {
    color: #1e90ff; /* Darker blue (Dodger Blue) in light mode */
}

.light-mode .content-box a:hover {
    color: #104e8b; /* Even darker blue on hover in light mode */
}

.light-mode .gray-box {
    background-color: #e5e5e5; /* Darker gray for better contrast with content-box (#f5f5f5) */
    border-color: #ccc;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.light-mode .gray-box pre {
    border: 1px solid #999; /* Adjusted frame color for light mode */
    background-color: #d5d5d5; /* Slightly darker than gray-box background */
}

.light-mode .yellow-box {
    background-color: #fffff4;
    border-color: #ffff66;
    color: #333;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.light-mode .cyan-box {
    background-color: #e6ffff;
    border-color: #00cccc;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.light-mode .red-box {
    background-color: #fff4f4;
    border-color: #ff6666;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

.light-mode .green-box {
    background-color: #f4fff4;
    border-color: #66ff66;
    word-break: break-word; /* Break long words */
    overflow-wrap: break-word; /* Fallback for older browsers */
    white-space: normal; /* Allow wrapping at spaces */
    box-sizing: border-box;
}

/* Footer */
footer {
    margin-top: 40px;
    font-size: 14px;
    color: #666;
}

footer p {
    margin: 5px 0; /* Add spacing between paragraphs in the footer */
}

footer a.a_orange {
    color: #ffa500; /* Orange in dark mode */
    text-decoration: none;
}

footer a.a_orange:hover {
    color: #cc8400; /* Darker orange on hover in dark mode */
}

.light-mode footer {
    color: #999;
}

.light-mode footer a.a_orange {
    color: #ff4500; /* OrangeRed in light mode */
}

.light-mode footer a.a_orange:hover {
    color: #cc3700; /* Darker OrangeRed on hover in light mode */
}

/* Textarea Base Styling (Shared Properties) */
textarea {
    width: 90%;
    height: 150px;
    padding: 8px;
    margin: 0 auto;
    font-size: 14px;
    font-family: 'Courier New', Courier, monospace;
    border-radius: 4px;
    resize: vertical;
    box-sizing: border-box;
    display: block;
    text-align: left;
    white-space: pre-wrap; /* Enables wrapping while preserving line breaks */
    overflow-y: auto; /* Enables vertical scrolling if content overflows */
}

/* Textarea for Gray Box */
.textarea-gray {
    border: 1px solid #444; /* Matches gray-box border in dark mode */
    background-color: #242424; /* Slightly darker than gray-box background */
    color: #f0f0f0; /* Matches body text color in dark mode */
}

.light-mode .textarea-gray {
    border: 1px solid #ccc; /* Matches gray-box border in light mode */
    background-color: #d5d5d5; /* Slightly darker than gray-box background */
    color: #333; /* Matches body text color in light mode */
}

/* Textarea for Yellow Box */
.textarea-yellow {
    border: 1px solid #ffff44; /* Matches yellow-box border in dark mode */
    background-color: #3e3e24; /* Slightly darker than yellow-box background */
    color: #f0f0f0; /* Matches body text color in dark mode */
}

.light-mode .textarea-yellow {
    border: 1px solid #ffff66; /* Matches yellow-box border in light mode */
    background-color: #fafae6; /* Slightly darker than yellow-box background */
    color: #333; /* Matches body text color in light mode */
}

/* Textarea for Cyan Box */
.textarea-cyan {
    border: 1px solid #44ffff; /* Matches cyan-box border in dark mode */
    background-color: #1a3a3a; /* Slightly darker than cyan-box background */
    color: #f0f0f0; /* Matches body text color in dark mode */
}

.light-mode .textarea-cyan {
    border: 1px solid #00cccc; /* Matches cyan-box border in light mode */
    background-color: #d6fafa; /* Slightly darker than cyan-box background */
    color: #333; /* Matches body text color in light mode */
}

/* Textarea for Red Box */
.textarea-red {
    border: 1px solid #ff4444; /* Matches red-box border in dark mode */
    background-color: #3a2424; /* Slightly darker than red-box background */
    color: #f0f0f0; /* Matches body text color in dark mode */
}

.light-mode .textarea-red {
    border: 1px solid #ff6666; /* Matches red-box border in light mode */
    background-color: #fae6e6; /* Slightly darker than red-box background */
    color: #333; /* Matches body text color in light mode */
}

/* Textarea for Green Box */
.textarea-green {
    border: 1px solid #44ff44; /* Matches green-box border in dark mode */
    background-color: #1e3a1e; /* Slightly darker than green-box background */
    color: #f0f0f0; /* Matches body text color in dark mode */
}

.light-mode .textarea-green {
    border: 1px solid #66ff66; /* Matches green-box border in light mode */
    background-color: #e6ffe6; /* Slightly darker than green-box background */
    color: #333; /* Matches body text color in light mode */
}

/* Responsive Design for Mobile */
@media (max-width: 600px) {
    body {
        padding: 10px;
    }
    .content-box, .gray-box, .yellow-box, .cyan-box, .red-box, .green-box {
        padding: 10px;
    }
    .gray-box pre {
        font-size: 12px;
    }
    textarea {
        width: 100%;
        font-size: 12px;
    }
    h1 {
        font-size: 1.5em; /* Reduce heading size on smaller screens */
    }
    h2 {
        font-size: 1.3em;
    }
    h3 {
        font-size: 1.1em;
    }
}

</style>
