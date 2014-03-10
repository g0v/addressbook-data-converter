require! <[cheerio request async]>

export function parse-set-datagov(cnt)
  $ = cheerio.load cnt
  name = $ 'h1[class="title"]' .text!
  url = $ '#node_metadataset_full_group_data_type' 
    .find 'div .field-item' 
    .find \a 
    .attr \href
  [name, url]