package de.dittner.appIconResizer.ui.common.dialogBox {
import de.dittner.appIconResizer.ui.common.popup.SimplePopup;
import de.dittner.appIconResizer.utils.AppColors;
import de.dittner.async.IAsyncOperation;

public class DialogBox {
	public function DialogBox() {}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private static var notificationDialog:NotificationDialog;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public static function showNotification(msg:String):Boolean {
		if (!notificationDialog) {
			notificationDialog = new NotificationDialog();
		}

		var op:IAsyncOperation = notificationDialog.show(msg);
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			SimplePopup.close();
		});

		notificationDialog.horizontalCenter = 0;
		notificationDialog.bottom = 100;
		return SimplePopup.show(notificationDialog, false, null, AppColors.ERROR, 0.1);
	}

}
}
