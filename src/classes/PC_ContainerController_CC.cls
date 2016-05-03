/**
 * Controller for PC Container page
 *
 * @author  Krzysztof Wasniowski <k.wasniowski@polsource.com>
 */
public with sharing class PC_ContainerController_CC
{
    /**
     * Class constructor
     */
    public PC_ContainerController_CC()
    {
        // add header to force IE to use IE=10 compability mode
        ApexPages.currentPage().getHeaders().put('x-ua-compatible', 'IE=10');
    }
}