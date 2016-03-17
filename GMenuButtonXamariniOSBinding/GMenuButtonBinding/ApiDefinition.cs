using System;

using UIKit;
using Foundation;
using ObjCRuntime;
using CoreGraphics;

namespace GMenuButtonBinding
{
	// The first step to creating a binding is to add your native library ("libNativeLibrary.a")
	// to the project by right-clicking (or Control-clicking) the folder containing this source
	// file and clicking "Add files..." and then simply select the native library (or libraries)
	// that you want to bind.
	//
	// When you do that, you'll notice that MonoDevelop generates a code-behind file for each
	// native library which will contain a [LinkWith] attribute. MonoDevelop auto-detects the
	// architectures that the native library supports and fills in that information for you,
	// however, it cannot auto-detect any Frameworks or other system libraries that the
	// native library may depend on, so you'll need to fill in that information yourself.
	//
	// Once you've done that, you're ready to move on to binding the API...
	//
	//
	// Here is where you'd define your API definition for the native Objective-C library.
	//
	// For example, to bind the following Objective-C class:
	//
	//     @interface Widget : NSObject {
	//     }
	//
	// The C# binding would look like this:
	//
	//     [BaseType (typeof (NSObject))]
	//     interface Widget {
	//     }
	//
	// To bind Objective-C properties, such as:
	//
	//     @property (nonatomic, readwrite, assign) CGPoint center;
	//
	// You would add a property definition in the C# interface like so:
	//
	//     [Export ("center")]
	//     CGPoint Center { get; set; }
	//
	// To bind an Objective-C method, such as:
	//
	//     -(void) doSomething:(NSObject *)object atIndex:(NSInteger)index;
	//
	// You would add a method definition to the C# interface like so:
	//
	//     [Export ("doSomething:atIndex:")]
	//     void DoSomething (NSObject object, int index);
	//
	// Objective-C "constructors" such as:
	//
	//     -(id)initWithElmo:(ElmoMuppet *)elmo;
	//
	// Can be bound as:
	//
	//     [Export ("initWithElmo:")]
	//     IntPtr Constructor (ElmoMuppet elmo);
	//
	// For more information, see http://developer.xamarin.com/guides/ios/advanced_topics/binding_objective-c/
	//
	// @protocol GMenuButtonDelegate <NSObject>
	[Protocol, Model]
	[BaseType (typeof (NSObject))]
	interface GMenuButtonDelegate {

		// @optional -(void)itemClicked:(int)index;
		[Export ("itemClicked:")]
		void ItemClicked (nint index);
		[Export ("menuButtonClicked")]
		void menuButtonClicked();
	}

	// @interface AnimatedMenuButton : UIButton
	[BaseType (typeof (UIButton))]
	interface AnimatedMenuButton {

		// -(instancetype)initWithFrame:(CGRect)rect Images:(NSMutableArray *)items withParentView:(UIView *)parent;
		[Export ("initWithFrame:Images:withParentView:")]
		IntPtr Constructor (CGRect rect, NSMutableArray items, UIView parent);

		// @property (readonly, nonatomic, strong) UIScrollView * contentView;
		[Export ("contentView", ArgumentSemantic.Retain)]
		UIScrollView ContentView { get; }

		// @property (readonly, nonatomic, strong) UIView * backgroundView;
		[Export ("backgroundView", ArgumentSemantic.Retain)]
		UIView BackgroundView { get; }

		// @property (readonly, nonatomic, strong) UIView * parentView;
		[Export ("parentView", ArgumentSemantic.Retain)]
		UIView ParentView { get; }

		// @property (nonatomic) int clickedButtonIndex;
		[Export ("clickedButtonIndex")]
		int ClickedButtonIndex { get; set; }

		// @property (nonatomic) _Bool deafultAlignment;
		[Export ("deafultAlignment")]
		bool DeafultAlignment { get; set; }

		[Export ("fixedContentSize")]
		bool FixedContentSize { get; set; }

		// @property (nonatomic, strong) UIColor * primaryColor;
		[Export ("primaryColor", ArgumentSemantic.Retain)]
		UIColor PrimaryColor { get; set; }

		// @property (nonatomic, strong) UIColor * secondaryColor;
		[Export ("secondaryColor", ArgumentSemantic.Retain)]
		UIColor SecondaryColor { get; set; }

		// @property (nonatomic, strong) NSMutableArray * itemViews;
		[Export ("itemViews", ArgumentSemantic.Retain)]
		NSMutableArray ItemViews { get; set; }

		// @property (nonatomic, weak) id<GMenuButtonDelegate> delegate;
		[Export ("delegate", ArgumentSemantic.Weak)]
		[NullAllowed]
		NSObject WeakDelegate { get; set; }

		// @property (nonatomic, weak) id<GMenuButtonDelegate> delegate;
		[Wrap ("WeakDelegate")]
		GMenuButtonDelegate Delegate { get; set; }

		// -(void)closeMenu;
		[Export ("closeMenu")]
		void CloseMenu ();
	}

	// @interface GMenuButton : NSObject
//	[BaseType (typeof (NSObject))]
//	interface GMenuButton {
//
//	}

	// @interface MaterialDesign (UIView)
	[Category]
	[BaseType (typeof (UIView))]
	interface MaterialDesign {

		// -(void)mdInflateAnimatedFromPoint:(CGPoint)point backgroundColor:(UIColor *)backgroundColor duration:(NSTimeInterval)duration completion:(void (^)(void))block;
		[Export ("mdInflateAnimatedFromPoint:backgroundColor:duration:completion:")]
		void MdInflateAnimatedFromPoint (CGPoint point, UIColor backgroundColor, double duration, Action block);

		// -(void)mdDeflateAnimatedToPoint:(CGPoint)point backgroundColor:(UIColor *)backgroundColor duration:(NSTimeInterval)duration completion:(void (^)(void))block;
		[Export ("mdDeflateAnimatedToPoint:backgroundColor:duration:completion:")]
		void MdDeflateAnimatedToPoint (CGPoint point, UIColor backgroundColor, double duration, Action block);

		// +(void)mdInflateTransitionFromView:(UIView *)fromView toView:(UIView *)toView originalPoint:(CGPoint)originalPoint duration:(NSTimeInterval)duration completion:(void (^)(void))block;
		[Static, Export ("mdInflateTransitionFromView:toView:originalPoint:duration:completion:")]
		void MdInflateTransitionFromView (UIView fromView, UIView toView, CGPoint originalPoint, double duration, Action block);

		// +(void)mdDeflateTransitionFromView:(UIView *)fromView toView:(UIView *)toView originalPoint:(CGPoint)originalPoint duration:(NSTimeInterval)duration completion:(void (^)(void))block;
		[Static, Export ("mdDeflateTransitionFromView:toView:originalPoint:duration:completion:")]
		void MdDeflateTransitionFromView (UIView fromView, UIView toView, CGPoint originalPoint, double duration, Action block);
	}
}
