<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>الكاسر: ملك النار 🔥</title>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      user-select: none;
      -webkit-user-select: none;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body, html {
      width: 100%;
      height: 100%;
      overflow: hidden;
      background-color: #050202;
      color: #fff;
    }

    #canvas-container {
      width: 100%;
      height: 100%;
      position: absolute;
      top: 0;
      left: 0;
      z-index: 1;
    }

    /* UI Overlay Layer */
    .ui-layer {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: 10;
      pointer-events: none;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 15px;
    }

    /* Top HUD */
    .hud-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: rgba(15, 5, 5, 0.75);
      border: 2px solid #ff9900;
      box-shadow: 0 0 15px rgba(255, 68, 0, 0.4);
      border-radius: 12px;
      padding: 10px 20px;
      pointer-events: auto;
    }

    .health-bar-container {
      width: 180px;
      height: 22px;
      background: #220505;
      border: 2px solid #ff3300;
      border-radius: 10px;
      overflow: hidden;
      position: relative;
    }

    .health-bar-fill {
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, #ff0000, #ff9900);
      box-shadow: 0 0 10px #ff3300;
      transition: width 0.2s ease;
    }

    .score-box {
      font-size: 1.2rem;
      font-weight: bold;
      color: #ffd700;
      text-shadow: 0 0 8px #ff4500;
    }

    .sound-btn {
      background: #221005;
      border: 1px solid #ffd700;
      color: #ffd700;
      padding: 5px 10px;
      border-radius: 8px;
      cursor: pointer;
      font-size: 0.9rem;
    }

    /* Controls Layer */
    .controls-container {
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
      width: 100%;
      margin-bottom: 10px;
      pointer-events: auto;
    }

    .dpad, .action-pad {
      display: flex;
      gap: 15px;
    }

    .btn-ctrl {
      width: 65px;
      height: 65px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(255, 69, 0, 0.8) 0%, rgba(80, 10, 0, 0.9) 100%);
      border: 2px solid #ffd700;
      box-shadow: 0 0 12px rgba(255, 140, 0, 0.6);
      color: #fff;
      font-size: 1.5rem;
      font-weight: bold;
      display: flex;
      justify-content: center;
      align-items: center;
      touch-action: manipulation;
      cursor: pointer;
    }

    .btn-ctrl:active {
      transform: scale(0.92);
      background: radial-gradient(circle, rgba(255, 215, 0, 0.9) 0%, rgba(150, 20, 0, 1) 100%);
    }

    .btn-attack {
      width: 75px;
      height: 75px;
      background: radial-gradient(circle, rgba(255, 0, 0, 0.9) 0%, rgba(100, 0, 0, 1) 100%);
      border: 3px solid #ffcc00;
      font-size: 1.8rem;
    }

    /* Start / Game Over Screens */
    .modal-screen {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: radial-gradient(circle, rgba(40, 5, 0, 0.95) 0%, rgba(5, 0, 0, 0.98) 100%);
      z-index: 100;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
      padding: 20px;
    }

    .game-title {
      font-size: 2.8rem;
      font-weight: 900;
      color: #ffd700;
      text-shadow: 0 0 10px #ff0000, 0 0 20px #ff6600, 0 0 30px #ff0000;
      margin-bottom: 15px;
      animation: firePulse 1.5s infinite alternate;
    }

    @keyframes firePulse {
      0% { text-shadow: 0 0 10px #ff0000, 0 0 20px #ff6600; }
      100% { text-shadow: 0 0 20px #ffdd00, 0 0 35px #ff0000; }
    }

    .subtitle {
      font-size: 1.1rem;
      color: #ffaa55;
      margin-bottom: 30px;
    }

    .main-btn {
      padding: 15px 40px;
      font-size: 1.5rem;
      font-weight: bold;
      color: #000;
      background: linear-gradient(180deg, #ffe600, #ff5500);
      border: 2px solid #fff;
      border-radius: 30px;
      box-shadow: 0 0 20px rgba(255, 102, 0, 0.8);
      cursor: pointer;
      pointer-events: auto;
    }

    .main-btn:active {
      transform: scale(0.95);
    }

    .hidden {
      display: none !important;
    }
  </style>

  <!-- Import Three.js Library -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
</head>
<body>

  <!-- Three.js Canvas Container -->
  <div id="canvas-container"></div>

  <!-- HUD Interface -->
  <div class="ui-layer">
    <div class="hud-header">
      <div class="health-bar-container">
        <div id="health-fill" class="health-bar-fill"></div>
      </div>
      <div class="score-box">النقاط: <span id="score-val">0</span></div>
      <button id="sound-toggle" class="sound-btn">الصوت: 🔊</button>
    </div>

    <!-- On-Screen Controls -->
    <div class="controls-container">
      <div class="dpad">
        <div id="btn-left" class="btn-ctrl">◀</div>
        <div id="btn-right" class="btn-ctrl">▶</div>
      </div>
      <div class="action-pad">
        <div id="btn-jump" class="btn-ctrl">▲</div>
        <div id="btn-attack" class="btn-ctrl btn-attack">🔥</div>
      </div>
    </div>
  </div>

  <!-- Start Screen -->
  <div id="start-screen" class="modal-screen">
    <h1 class="game-title">الكاسر: ملك النار</h1>
    <p class="subtitle">اقتل الأعداء واحْمِ عرش النار!</p>
    <button id="start-btn" class="main-btn">ابدأ المعركة 🔥</button>
  </div>

  <!-- Game Over Screen -->
  <div id="gameover-screen" class="modal-screen hidden">
    <h1 class="game-title" style="color: #ff3333;">انتهت المعركة!</h1>
    <p class="subtitle">النتيجة النهائية: <span id="final-score" style="color: #ffd700;">0</span></p>
    <button id="restart-btn" class="main-btn">إعادة اللعب 🔄</button>
  </div>

  <script>
    /* ================= SYSTEM AUDIO (Web Audio API) ================= */
    let audioCtx = null;
    let soundEnabled = true;

    function initAudio() {
      if (!audioCtx) {
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
      }
    }

    function playSound(type) {
      if (!soundEnabled || !audioCtx) return;
      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();
      osc.connect(gain);
      gain.connect(audioCtx.destination);

      const now = audioCtx.currentTime;
      if (type === 'attack') {
        osc.type = 'sawtooth';
        osc.frequency.setValueAtTime(400, now);
        osc.frequency.exponentialRampToValueAtTime(80, now + 0.2);
        gain.gain.setValueAtTime(0.3, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.2);
        osc.start(now);
        osc.stop(now + 0.2);
      } else if (type === 'jump') {
        osc.type = 'sine';
        osc.frequency.setValueAtTime(150, now);
        osc.frequency.exponentialRampToValueAtTime(450, now + 0.25);
        gain.gain.setValueAtTime(0.3, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.25);
        osc.start(now);
        osc.stop(now + 0.25);
      } else if (type === 'hit') {
        osc.type = 'square';
        osc.frequency.setValueAtTime(100, now);
        osc.frequency.exponentialRampToValueAtTime(30, now + 0.3);
        gain.gain.setValueAtTime(0.4, now);
        gain.gain.exponentialRampToValueAtTime(0.01, now + 0.3);
        osc.start(now);
        osc.stop(now + 0.3);
      }
    }

    /* ================= GAME ENGINE & THREE.JS SETUP ================= */
    let scene, camera, renderer;
    let player, sword, enemies = [], particles = [];
    let isPlaying = false;
    let score = 0;
    let health = 100;

    // Movement state
    let moveLeft = false, moveRight = false, isJumping = false, isAttacking = false;
    let playerVelY = 0;
    const gravity = -0.015;

    function initThree() {
      const container = document.getElementById('canvas-container');
      scene = new THREE.Scene();
      scene.fog = new THREE.FogExp2(0x1a0500, 0.03);

      camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 0.1, 1000);
      camera.position.set(0, 3, 9);

      renderer = new THREE.WebGLRenderer({ antialias: true });
      renderer.setSize(window.innerWidth, window.innerHeight);
      renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
      renderer.shadowMap.enabled = true;
      container.appendChild(renderer.domElement);

      // Lights
      const ambientLight = new THREE.AmbientLight(0xff6633, 0.6);
      scene.add(ambientLight);

      const dirLight = new THREE.DirectionalLight(0xffd700, 1);
      dirLight.position.set(5, 10, 7);
      dirLight.castShadow = true;
      scene.add(dirLight);

      // Lava Floor
      const floorGeo = new THREE.PlaneGeometry(60, 20);
      const floorMat = new THREE.MeshStandardMaterial({ color: 0x220500, roughness: 0.8 });
      const floor = new THREE.Mesh(floorGeo, floorMat);
      floor.rotation.x = -Math.PI / 2;
      floor.position.y = 0;
      floor.receiveShadow = true;
      scene.add(floor);

      // Build Hero (Al-Kaser)
      buildHero();

      window.addEventListener('resize', onWindowResize);
    }

    function buildHero() {
      player = new THREE.Group();

      // Body
      const bodyGeo = new THREE.BoxGeometry(0.8, 1.2, 0.5);
      const bodyMat = new THREE.MeshStandardMaterial({ color: 0xcc9900, metalness: 0.8, roughness: 0.2 });
      const body = new THREE.Mesh(bodyGeo, bodyMat);
      body.position.y = 0.6;
      body.castShadow = true;
      player.add(body);

      // Head
      const headGeo = new THREE.SphereGeometry(0.35, 16, 16);
      const headMat = new THREE.MeshStandardMaterial({ color: 0xff3300, emissive: 0x990000 });
      const head = new THREE.Mesh(headGeo, headMat);
      head.position.y = 1.4;
      player.add(head);

      // Fire Sword
      const swordGeo = new THREE.BoxGeometry(0.1, 1.2, 0.1);
      const swordMat = new THREE.MeshStandardMaterial({ color: 0xff4500, emissive: 0xff2200, emissiveIntensity: 0.8 });
      sword = new THREE.Mesh(swordGeo, swordMat);
      sword.position.set(0.6, 0.8, 0.3);
      sword.rotation.z = -Math.PI / 4;
      player.add(sword);

      player.position.set(0, 0, 0);
      scene.add(player);
    }

    function spawnEnemy() {
      if (!isPlaying) return;
      const side = Math.random() > 0.5 ? 1 : -1;
      const enemyGeo = new THREE.BoxGeometry(0.7, 1.0, 0.5);
      const enemyMat = new THREE.MeshStandardMaterial({ color: 0x880000, roughness: 0.5 });
      const enemy = new THREE.Mesh(enemyGeo, enemyMat);
      enemy.position.set(side * 12, 0.5, 0);
      enemy.castShadow = true;

      scene.add(enemy);
      enemies.push(enemy);
    }

    function triggerParticles(pos) {
      for (let i = 0; i < 12; i++) {
        const pGeo = new THREE.SphereGeometry(0.08, 8, 8);
        const pMat = new THREE.MeshBasicMaterial({ color: 0xffcc00 });
        const p = new THREE.Mesh(pGeo, pMat);
        p.position.copy(pos);
        p.userData = {
          vx: (Math.random() - 0.5) * 0.2,
          vy: Math.random() * 0.2,
          vz: (Math.random() - 0.5) * 0.2,
          life: 1.0
        };
        scene.add(p);
        particles.push(p);
      }
    }

    /* ================= CONTROLS & EVENTS ================= */
    function setupControls() {
      // Touch / Buttons
      const bindBtn = (id, onPress, onRelease) => {
        const el = document.getElementById(id);
        el.addEventListener('touchstart', (e) => { e.preventDefault(); onPress(); });
        el.addEventListener('touchend', (e) => { e.preventDefault(); onRelease(); });
        el.addEventListener('mousedown', () => onPress());
        el.addEventListener('mouseup', () => onRelease());
      };

      bindBtn('btn-left', () => moveLeft = true, () => moveLeft = false);
      bindBtn('btn-right', () => moveRight = true, () => moveRight = false);
      bindBtn('btn-jump', () => { if (!isJumping) { isJumping = true; playerVelY = 0.28; playSound('jump'); } }, () => {});
      bindBtn('btn-attack', () => performAttack(), () => {});

      // Keyboard Controls
      window.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowLeft' || e.key === 'a') moveLeft = true;
        if (e.key === 'ArrowRight' || e.key === 'd') moveRight = true;
        if ((e.key === 'ArrowUp' || e.key === 'w' || e.key === ' ') && !isJumping) {
          isJumping = true;
          playerVelY = 0.28;
          playSound('jump');
        }
        if (e.key === 'f' || e.key === 'j') performAttack();
      });

      window.addEventListener('keyup', (e) => {
        if (e.key === 'ArrowLeft' || e.key === 'a') moveLeft = false;
        if (e.key === 'ArrowRight' || e.key === 'd') moveRight = false;
      });

      document.getElementById('start-btn').addEventListener('click', startGame);
      document.getElementById('restart-btn').addEventListener('click', startGame);

      document.getElementById('sound-toggle').addEventListener('click', () => {
        soundEnabled = !soundEnabled;
        document.getElementById('sound-toggle').innerText = soundEnabled ? 'الصوت: 🔊' : 'الصوت: 🔇';
      });
    }

    function performAttack() {
      if (isAttacking) return;
      isAttacking = true;
      playSound('attack');

      // Sword Swing Anim
      sword.rotation.z = Math.PI / 2;
      setTimeout(() => {
        sword.rotation.z = -Math.PI / 4;
        isAttacking = false;
      }, 200);

      // Hit Check
      enemies.forEach((enemy, idx) => {
        const dist = player.position.distanceTo(enemy.position);
        if (dist < 2.2) {
          triggerParticles(enemy.position);
          scene.remove(enemy);
          enemies.splice(idx, 1);
          score += 10;
          document.getElementById('score-val').innerText = score;
        }
      });
    }

    function startGame() {
      initAudio();
      score = 0;
      health = 100;
      isPlaying = true;

      document.getElementById('score-val').innerText = score;
      document.getElementById('health-fill').style.width = '100%';
      document.getElementById('start-screen').classList.add('hidden');
      document.getElementById('gameover-screen').classList.add('hidden');

      // Clear enemies
      enemies.forEach(e => scene.remove(e));
      enemies = [];
      player.position.set(0, 0, 0);
    }

    function gameOver() {
      isPlaying = false;
      document.getElementById('final-score').innerText = score;
      document.getElementById('gameover-screen').classList.remove('hidden');
    }

    function onWindowResize() {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
    }

    /* ================= GAME LOOP ================= */
    let spawnTimer = 0;

    function animate() {
      requestAnimationFrame(animate);

      if (isPlaying) {
        // Player Horizontal Move
        if (moveLeft && player.position.x > -8) player.position.x -= 0.12;
        if (moveRight && player.position.x < 8) player.position.x += 0.12;

        // Player Jump Physics
        if (isJumping) {
          player.position.y += playerVelY;
          playerVelY += gravity;
          if (player.position.y <= 0) {
            player.position.y = 0;
            isJumping = false;
          }
        }

        // Camera Follow
        camera.position.x = player.position.x * 0.4;

        // Spawn Enemies
        spawnTimer++;
        if (spawnTimer > 100) {
          spawnEnemy();
          spawnTimer = 0;
        }

        // Enemies Loop
        enemies.forEach((enemy, idx) => {
          const dir = player.position.x > enemy.position.x ? 1 : -1;
          enemy.position.x += dir * 0.04;

          // Check Collision with Player
          if (player.position.distanceTo(enemy.position) < 0.9) {
            health -= 0.5;
            document.getElementById('health-fill').style.width = health + '%';
            playSound('hit');

            if (health <= 0) {
              gameOver();
            }
          }
        });

        // Particles Loop
        particles.forEach((p, idx) => {
          p.position.x += p.userData.vx;
          p.position.y += p.userData.vy;
          p.position.z += p.userData.vz;
          p.userData.life -= 0.03;
          p.scale.setScalar(p.userData.life);
          if (p.userData.life <= 0) {
            scene.remove(p);
            particles.splice(idx, 1);
          }
        });
      }

      renderer.render(scene, camera);
    }

    // Initialize Game
    initThree();
    setupControls();
    animate();
  </script>
</body>
</html>