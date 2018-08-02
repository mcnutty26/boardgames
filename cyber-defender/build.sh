rm -rf out
mkdir out
mkdir out/cards
mkdir out/cards/incidents
mkdir out/boards
mkdir out/cardsheets
mkdir out/gameboards

echo "Processing incidents"
for filename in cards/incidents/*.md; do
  echo $filename
  pandoc --from=markdown --smart --template layouts/incident.latex -o out/cards/incidents/"$(basename "$filename" .md)".pdf --latex-engine=xelatex $filename
  convert -density 72 -depth 8 -quality 85 out/cards/incidents/"$(basename "$filename" .md)".pdf out/cards/incidents/"$(basename "$filename" .md)".png
done

echo "Creating incident card sheets"
pdfjam out/cards/incidents/*.pdf --no-landscape --frame true --nup 5x4 --suffix complete --outfile out/cardsheets/incidents.pdf
montage -verbose -define png:size=484x744 -geometry 484x744+2+2 -tile 10x7 out/cards/incidents/*.png out/cardsheets/incidents.png

echo "Processing manual…"
pandoc --from=markdown+yamlmetadata_block --smart --template _layouts/manual_print.latex -o out/manual.pdf --latex-engine=xelatex manual.md
