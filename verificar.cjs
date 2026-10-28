const fs = require('node:fs');
const http = require('node:http');
const assert = require('node:assert/strict');
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || '@playwright/test');
(async () => {
 const server = http.createServer((req,res)=>{res.setHeader('Content-Type','text/html; charset=utf-8');res.end(fs.readFileSync('index.html'));});
 await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
 const browser = await chromium.launch({headless:true,channel:'msedge'});
 try {
  const page = await browser.newPage({viewport:{width:1440,height:1000}});
  const errors=[];page.on('pageerror',e=>errors.push(e.message));page.on('dialog',d=>d.accept());
  await page.goto(process.env.TEST_URL || `http://127.0.0.1:${server.address().port}`);
  await page.evaluate(()=>localStorage.clear());await page.reload();
  const text=id=>page.locator('#'+id).textContent();
  const row=()=>page.locator('.item').filter({hasText:'Bombons de Morango'});
  const edit=async(field,value)=>{const input=row().locator(`[data-field="${field}"]`);await input.fill(value);await input.press('Tab');};
  assert.equal(await text('kpiTarget'),'360');assert.equal(await text('kpiChecked'),'0/4');
  await edit('produced','120');await edit('actual','0');
  assert.match(await row().innerText(),/Com pendência/);assert.equal(await text('kpiChecked'),'1/4');
  await edit('actual','100');assert.equal(await text('kpiActual'),'100');assert.equal(await text('kpiOpen'),'260');
  await row().locator('[data-field="reason"]').selectOption('Falta de insumos');
  await row().locator('[data-action="note"]').click();await edit('note','Simulação de teste');
  await page.reload();assert.equal(await row().locator('[data-field="actual"]').inputValue(),'100');assert.equal(await row().locator('[data-field="reason"]').inputValue(),'Falta de insumos');
  await edit('actual','121');assert.equal(await row().locator('[data-field="actual"]').inputValue(),'100');
  await edit('produced','99');assert.equal(await row().locator('[data-field="produced"]').inputValue(),'120');
  await edit('actual','');assert.match(await row().innerText(),/Sem apontamento/);
  await edit('actual','120');assert.match(await row().innerText(),/Concluído/);
  await edit('produced','130');await edit('actual','130');assert.match(await row().innerText(),/Acima da meta/);assert.equal(await text('kpiOpen'),'240');
  await row().locator('[data-action="edit"]').click();await page.locator('#alloc_AN').fill('0');
  await page.locator('#planForm button[type="submit"]').click();assert.match(await text('fieldError'),/soma/);
  await page.locator('#alloc_NO').fill('65');await page.locator('#planForm button[type="submit"]').click();
  await page.locator('#storeFilter').selectOption('AN');assert.equal(await page.locator('.item').count(),3);assert.equal(await text('kpiTarget'),'240');assert.equal(await text('kpiActual'),'0');
  await page.locator('#storeFilter').selectOption('all');assert.equal(await text('kpiActual'),'130');
  await page.locator('#search').fill('Bombons');
  const downloadPromise=page.waitForEvent('download');await page.locator('#export').click();const download=await downloadPromise;
  const stream=await download.createReadStream();const chunks=[];for await(const chunk of stream)chunks.push(chunk);const csv=Buffer.concat(chunks).toString('utf8');
  assert.equal(csv.trim().split('\r\n').length,2);assert.match(csv,/Produzidos apontados/);assert.match(csv,/Simulação de teste/);assert.match(csv,/FICTICIAS/);
  await page.locator('#search').fill('');await page.locator('#date').fill('2026-10-29');assert.equal(await page.locator('.item').count(),0);
  await page.locator('#add').click();await page.locator('#name').fill('Doce de teste');await page.locator('#target').fill('7');await page.locator('#split').click();
  assert.deepEqual(await page.locator('#allocInputs input').evaluateAll(inputs=>inputs.map(i=>i.value)),['2','2','2','1']);
  await page.locator('#planForm button[type="submit"]').click();assert.equal(await text('kpiTarget'),'7');
  await page.locator('.item [data-action="edit"]').click();await page.locator('#delete').click();assert.equal(await page.locator('.item').count(),0);
  await page.locator('#reset').click();await page.locator('#simulate').click();assert.equal(await text('kpiProduced'),'360');assert.equal(await text('kpiActual'),'289');assert.equal(await text('kpiOpen'),'71');
  await page.locator('#reset').click();
  fs.mkdirSync('test-results',{recursive:true});
  for(const width of [1440,1280,1024,768,390,320]){
   await page.setViewportSize({width,height:900});assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`Overflow em ${width}px`);
   await page.screenshot({path:`test-results/tela-${width}.png`,fullPage:true});
  }
  // Falha de persistência deve ficar visível sem impedir o uso da tela.
  const blocked=await browser.newContext();await blocked.addInitScript(()=>{Storage.prototype.setItem=function(){throw new DOMException('Indisponível','QuotaExceededError');};});
  const blockedPage=await blocked.newPage();await blockedPage.goto(`http://127.0.0.1:${server.address().port}`);
  assert.equal(await blockedPage.locator('#storageWarning').isVisible(),true);assert.equal(await blockedPage.locator('.item').count(),4);await blocked.close();
  assert.deepEqual(errors,[]);
  console.log('PASSOU: metas, nulo/zero, cálculos, excesso, validações, motivos, notas, persistência, filtros, CSV, edição, inclusão, exclusão, simulação e 6 larguras (320 a 1440px). Sem erros JavaScript.');
 } finally {await browser.close();server.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
