# كيف تحول هذا المشروع إلى APK (خطوات بسيطة)

هذا المشروع جاهز فيه ملفين معدّين مسبقاً حتى لا تحتاج تكتب أي كود بنفسك:
- `.github/workflows/build.yml` (لطريقة GitHub Actions)
- `codemagic.yaml` (لطريقة Codemagic)

اختر طريقة واحدة بس واتبعها.

## الطريقة الأولى: GitHub Actions (تحتاج فقط رفع الملفات)
1. أنشئ مستودع (repository) جديد وعام (Public) على github.com
2. ارفع كل ملفات هذا المشروع كما هي، بنفس الترتيب والمجلدات (احرص أن يبقى main.dart داخل مجلد lib، وأن يبقى ملف build.yml داخل مجلدي .github/workflows)
3. روح لتبويب Actions في صفحة المستودع
4. انتظر حتى تظهر علامة ✔ خضراء
5. افتح الـ run المكتمل، وحمّل الملف من قسم Artifacts

## الطريقة الثانية: Codemagic (بدون كتابة أي كود، بواجهة أسهل)
1. سجّل في codemagic.io بحساب GitHub نفسه (Continue with GitHub)
2. اضغط Add application واختر هذا المستودع (بعد رفعه على GitHub كما في الطريقة الأولى)
3. Codemagic يكتشف ملف codemagic.yaml تلقائياً
4. اضغط Start new build
5. بعد اكتمال البناء، حمّل ملف APK من قسم Artifacts
