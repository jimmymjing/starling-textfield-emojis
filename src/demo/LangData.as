// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 06/07/2018.
//
// =================================================================================================

package demo {
public class LangData {

    public static const MSG_EN:String = "<b>Normal Attacks<b>\n" +
            "Use a combination of {ico1} and {ico2} to\n" +
            "unleash many different types of <u>attacks</u>. {ico2}\n" +
            "{starling} rocks! {:)}";

    public static const MSG_GR:String = "Κανονικές επιθέσεις\n" +
            "Χρήση συνδυασμού {ico1} και {ico2} σε\n" +
            "εξαπολύστε πολλούς διαφορετικούς τύπους επιθέσεων.";

    // missing new lines :P
    public static const MSG_AR:String = "\nالهجمات العادية" +
            "استخدم مزيجًا من {ico1} و {ico2} إلى" +
            "لإطلاق العديد من أنواع الهجمات المختلفة.";


    public static const MSG_JP:String = "通常の攻撃\n" +
            "{ico1}と{ico2}の組み合わせを使用して、さまざまな種類の攻撃を発\n" +
            "えます。";

    public static const MSG_KO:String = "일반 공격\n" +
            "{ico1}와 {ico2}의 조합을 사용하여 여러 가지 유형의 공격을\n" +
            "일으킬 수 있습니다.";

    public static const MSG_RU:String = "Обычные атаки\n" +
            "Используйте комбинацию {ico1} и {ico2} для\n" +
            "чтобы развязать множество различных типов атак";

    public static const MSG_VT:String = "Tấn công bình thường\n" +
            "Sử dụng kết hợp {ico1} và {ico2} để\n" +
            "mở nhiều loại tấn công khác nhau.";



    private static var currentIndex:int = 0;
    private static const MESSAGES:Array = [
        LangData.MSG_EN,
        LangData.MSG_GR,
        LangData.MSG_AR,
        LangData.MSG_JP,
        LangData.MSG_KO,
        LangData.MSG_RU,
        LangData.MSG_VT
    ];

    public static function getNextLang():String {
        var msg:String = MESSAGES[currentIndex];
        if (++currentIndex >= MESSAGES.length) currentIndex = 0;
        return msg;
    }

    public function LangData() {
    }
}
}
