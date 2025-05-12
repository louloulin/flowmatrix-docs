const fs = require('fs');
const sharp = require('sharp');

// Read the SVG file
const svgBuffer = fs.readFileSync('./favicon.svg');

// Convert to PNG
sharp(svgBuffer)
  .resize(32, 32) // Favicon size
  .png()
  .toFile('../favicon.png')
  .then(() => {
    console.log('Favicon created successfully!');
  })
  .catch(err => {
    console.error('Error creating favicon:', err);
  });
