# MiniSOC v1.0

Bash tabanlı SSH log analiz ve uyarı projesi.

## Özellikler

- SSH başarısız girişimlerini IP adresine göre gruplama
- LOW, MEDIUM ve HIGH önem seviyeleri
- Uyarı kaydı ve tekrarları önleme (deduplication)
- Farklı tespit türlerini ilişkilendirme (correlation)
- Terminal üzerinden olay özeti

## Önem seviyeleri

| Başarısız giriş | Seviye |
|---|---|
| 1–5 | LOW |
| 6–10 | MEDIUM |
| 11 ve üzeri | HIGH |

## Gereksinimler

Linux, Bash ve standart komut satırı araçları.

## Çalıştırma

### Sözdizimi Kontrolü ve Çalıştırma

Proje dizininde terminali açarak aşağıdaki komutları çalıştırın.

**1. Sözdizimini kontrol etme**

```bash
bash -n minisoc.sh
```

Bu komut, scripti çalıştırmadan Bash sözdizimi hatalarını kontrol eder. Hata yoksa terminale herhangi bir çıktı vermez.

**2. MiniSOC'u çalıştırma**

```bash
bash minisoc.sh
```

Bu komut MiniSOC log analiz aracını çalıştırır.

## Sanal makine laboratuvarı

VirtualBox üzerinde iki sanal makineyle test edilebilir:

- **Ubuntu:** MiniSOC'un çalıştığı ve kayıtların analiz edildiği makine.
- **Kali Linux:** İzinli laboratuvar ortamında kontrollü SSH bağlantı testlerinin yapılabileceği makine.

Uygun ağ ve SSH yapılandırmasıyla Kali Linux'tan oluşturulan bağlantıların Ubuntu kayıtlarına yansıması ve MiniSOC tarafından analiz edilmesi gözlemlenebilir.

### Test akışı

1. İki sanal makineyi uygun bir laboratuvar ağına bağla.
2. Ubuntu'da SSH hizmetini ve kayıtları yapılandır.
3. Kali Linux'tan yalnızca kendi laboratuvar makinene kontrollü test bağlantıları yap.
4. Oluşan kayıtları MiniSOC ile analiz et.
5. Uyarıları ve korelasyon sonuçlarını incele.

Canlı test için ağ, SSH ve log yapılandırmasının doğrulanması gerekir.

## Doğrulama

- Bash sözdizimi kontrolü
- Önem seviyesi eşiklerinin kontrolü
- Tekrarlanan uyarıların engellenmesi testi
- Korelasyon testi

## Sorumluluk reddi

Eğitim ve laboratuvar amaçlıdır. Yalnızca test yapma izni bulunan sistemlerde kullanılmalıdır.
