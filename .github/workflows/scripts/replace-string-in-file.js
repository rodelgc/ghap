const { readFileSync, writeFileSync } = require("fs");

const args = process.argv.slice(2);
const file = args[0];
const searchValue = args[1];
const replacement = args[2];

// readFile(file, "utf8", (err, fileContent) => {
//   if (err) {
//     return console.log(err);
//   }
//   const newFileContent = fileContent.replace(searchValue, replacement);

//   writeFile(file, newFileContent, "utf8", (err) => {
//     if (err) return console.log(err);
//   });
// });

const content = readFileSync(file);
const newFileContent = content.toString().replace(searchValue, replacement);

writeFileSync(file, newFileContent);
