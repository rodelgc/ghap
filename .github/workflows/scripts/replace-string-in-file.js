const { readFile, writeFile } = require("fs");

const args = process.argv.slice(2);
const someFile = args[0];
const searchValue = args[1];
const replacement = args[2];

readFile(someFile, "utf8", (err, fileContent) => {
  if (err) {
    return console.log(err);
  }
  const newFileContent = fileContent.replace(searchValue, replacement);

  writeFile(someFile, newFileContent, "utf8", (err) => {
    if (err) return console.log(err);
  });
});
