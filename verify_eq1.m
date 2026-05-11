N = 8;  % 搴忓垪闀垮害锛堥€夎鏂囧父鐢ㄧ殑2鐨勫箓娆★級
% 鐢熸垚鏂规硶锛氶殢鏈虹浉浣?+ exp(1i*鐩镐綅)锛屼繚璇佹ā鍊间负1
a = exp(1i * 2 * pi * rand(N, 1));  % 闅忔満鍗曚綅妯″簭鍒梐
b = exp(1i * 2 * pi * rand(N, 1));  % 闅忔満鍗曚綅妯″簭鍒梑

% ---------- 3. 鏄剧ず搴忓垪淇℃伅 ----------
disp('=== 娴嬭瘯搴忓垪淇℃伅 ===');
fprintf('搴忓垪闀垮害 N = %d\n', N);
disp('闅忔満鍗曚綅妯″簭鍒?a锛堝厓绱犳ā鍊尖増1锛夛細');
for i = 1:N
    fprintf('a(%d) = %.4f + %.4fi  (|a|=%.4f)\n', i-1, real(a(i)), imag(a(i)), abs(a(i)));
end
disp(' ');
disp('闅忔満鍗曚綅妯″簭鍒?b锛堝厓绱犳ā鍊尖増1锛夛細');
for i = 1:N
    fprintf('b(%d) = %.4f + %.4fi  (|b|=%.4f)\n', i-1, real(b(i)), imag(b(i)), abs(b(i)));
end

% ---------- 4. 娴嬭瘯涓嶅悓寤惰繜蟿鐨勬儏鍐?----------
test_taus = [-8, -5, -2, 0, 1, 3, 7, 8]; % 瑕嗙洊鎵€鏈夊垎娈?
disp(' ');
disp('=== 鍏紡(1)闈炲懆鏈熶簰鐩稿叧楠岃瘉缁撴灉 ===');
for tau = test_taus
    rho = full_linear_cross_correlation(a, b, tau);
    
    % 鏍囨敞寤惰繜绫诲瀷
    if abs(tau) >= N
        type = '锛堣秴鍑鸿寖鍥?|蟿|鈮锛?;
    elseif tau > 0
        type = '锛堟寤惰繜 0鈮は勨墹N-1锛?;
    elseif tau < 0
        type = '锛堣礋寤惰繜 -(N-1)鈮は勨墹-1锛?;
    else
        type = '锛堥浂寤惰繜 蟿=0锛?;
    end
    
    % 鏄剧ず澶嶆暟缁撴灉锛堝疄閮?铏氶儴锛?
    fprintf('蟿=%2d %s锛毾?a,b)(蟿) = %.6f %+.6fi\n', ...
        tau, type, real(rho), imag(rho));
end
